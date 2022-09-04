-module(tcp_server_demo).

%% -compile(export_all).
-export([start/0, tcp_opts/0, send_by_socket/2]).

tcp_opts() ->
  [binary, {packet, 2}, {reuseaddr, true}, {nodelay, false}].

start() ->
  Access = application:get_env(esockd, access, [{allow, all}]),
  SockOpts =
    [{access_rules, Access},
     {acceptors, 8},
     {shutdown, infinity},
     {max_connections, 1000000},
     {tcp_options, tcp_opts()}],
  tcp_server:start(9999, SockOpts, config_behavior_impl).

send_by_socket(Transport, Socket) ->
  InfoBin = utf8_list:list_to_binary("我没有来"),
  tcp_server_send:send_data_by_socket(Transport, Socket, 111, InfoBin, config_behavior_impl).
