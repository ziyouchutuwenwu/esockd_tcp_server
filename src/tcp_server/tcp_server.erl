-module(tcp_server).

-export([start/3]).

start(Port, SockOpts, ConfigBehaviorImpl) ->
  ok = esockd:start(),
  MFArgs = {client_handler, start_link, [ConfigBehaviorImpl]},
  esockd:open(echo, Port, SockOpts, MFArgs).