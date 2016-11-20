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

-module(vmq_dashboard_http_handler).
-author("codeadict").

%% API
-export([init/3]).
-export([rest_init/2]).
-export([allowed_methods/2, content_types_provided/2, to_json/2]).
-export([trails/0]).

trails() ->
    Metadata =
        #{ get => #{ summary => "Get list of all available metrics."
                   , produces => ["application/json"]
                   , parameters =>
                         [#{ name => <<"metric">>
                           , description => <<"Metric Name">>
                           , in => <<"path">>
                           , required => true
                           , type => <<"string">>}
                         ]
                   }
         },
    [trails:trail("/metrics/:metric", ?MODULE, [], Metadata)].

init(_, _, _) -> {upgrade, protocol, cowboy_rest}.

rest_init(Req, _) -> {ok, Req, #{}}.

allowed_methods(Req, State) ->
    Methods = [<<"HEAD">>, <<"OPTIONS">>, <<"GET">>],
    {Methods, Req, State}.

content_types_provided(Req, State) ->
    CTypes = [{{<<"application">>, <<"json">>, []}, to_json}],
    {CTypes, Req, State}.

to_json(Req, State) ->
    {_MetricName, Req2} = cowboy_req:binding(metric, Req),
    Reply = #{<<>>, <<>>},
    Json = jsx:encode(Reply),
    {Json, Req2, State}.
