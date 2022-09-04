-module(tcp_server_send).

%% API
-export([send_data_by_socket/5]).

send_data_by_socket(Transport, Socket, Cmd, InfoBin, ConfigBehaviorImpl) ->
  SocketPackModule = ConfigBehaviorImpl:get_socket_package_module(),
  Data = SocketPackModule:pack(Cmd, InfoBin),
  Transport:send(Socket, Data),
  ok.