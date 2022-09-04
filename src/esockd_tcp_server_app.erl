%%%-------------------------------------------------------------------
%% @doc esockd_tcp_server public API
%% @end
%%%-------------------------------------------------------------------

-module(esockd_tcp_server_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    esockd_tcp_server_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
