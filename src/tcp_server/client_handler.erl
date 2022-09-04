-module(client_handler).

-export([start_link/3, init/3, recv_loop/3]).

start_link(Transport, Sock, ConfigBehaviorImpl) ->
	{ok, spawn_link(?MODULE, init, [Transport, Sock, ConfigBehaviorImpl])}.


init(Transport, Sock, ConfigBehaviorImpl) ->
  case Transport:wait(Sock) of
    {ok, NewSock} ->
      {ok, {ClientIp, ClientPort}} = inet:peername(Sock),
      ClientIpStr = inet:ntoa(ClientIp),

      % 连接回调
      SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
      SocketHandlerModule:on_client_connected(Transport, Sock, ClientIpStr, ClientPort),

      recv_loop(Transport, NewSock, ConfigBehaviorImpl);
    Error -> Error
  end.


recv_loop(Transport, Sock, ConfigBehaviorImpl) ->
	case Transport:recv(Sock, 0) of
		{ok, Data} ->
			SocketUnpackModule = ConfigBehaviorImpl:get_socket_package_module(),
      {Cmd, InfoBin} = SocketUnpackModule:unpack(Data),

      SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
      SocketHandlerModule:on_client_data(Transport, Sock, Cmd, InfoBin),
      recv_loop(Transport, Sock, ConfigBehaviorImpl);
		{error, Reason} ->
			SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
      SocketHandlerModule:on_disconnected(Sock, Reason),
			{stop, Reason}
	end.