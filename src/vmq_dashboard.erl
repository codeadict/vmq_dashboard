%% Copyright 2016, Dairon Medina <me@dairon.org>
%%
%% Licensed under the Apache License, Version 2.0 (the "License"); you may not
%% use this file except in compliance with the License. You may obtain a copy of
%% the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
%% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
%% License for the specific language governing permissions and limitations under
%% the License.

-module(vmq_dashboard).

-behaviour(gen_server).

%% OTP API
-export([start_link/0]).
-export([stop/0]).

%% gen_server API
-export([init/1, handle_call/3]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).
-export([handle_cast/2]).


start_link() ->
    case gen_server:start_link({local, ?MODULE}, ?MODULE, [], []) of
        {ok, Pid} -> {ok, Pid};
        {error, {already_started, Pid}} -> {ok, Pid}
    end.


stop() ->
    gen_server:call(?MODULE, stop).

init(_) ->
    {ok, Options} = application:get_env(vmq_dashboard, http_server),
    Port = proplists:get_value(port, Options),

    Handlers =
        [ cowboy_swagger_handler
        , vmq_dashboard_http_handler
        ],

    Routes =
        [ {"/", cowboy_static, {file, "www/index.html"}}
        , {"/favicon.ico", cowboy_static, {file, "www/static/favicon.ico"}}
        , {"/static/[...]", cowboy_static, {dir, "www/static"}}
          | trails:trails(Handlers)
        ],

    trails:store(Routes),
    Dispatch = trails:single_host_compile(Routes),
    {ok, _} = cowboy:start_http(http, 100, [{port, Port}], [{env, [{dispatch, Dispatch}]}]),
    {ok, []}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State}.

handle_cast(shutdown, State) ->
    {stop, normal, State}.

handle_info(_Info, State) -> {noreply, State}.

%% default gen_server callbacks
terminate(_Reason, _State) ->  ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
