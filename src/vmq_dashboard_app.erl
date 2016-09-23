-module(vmq_dashboard_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  vernemq_demo_plugin_sup:start_link().

stop(_State) ->
  ok.

init() ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/", cowboy_static, {priv_file, vmq_dashboard, "www/index.html"}},
      {"/static/[...]", cowboy_static, {priv_dir, vmq_dashboard, "www/static"}}
    ]}
  ]),
  {ok, _} = cowboy:start_http(http, 100, [{port, 9000}], [
    {env, [{dispatch, Dispatch}]}
  ]),


  ok.
