-module(tcp_server_socket_handler_behavior).

-callback on_client_connected(Transport :: module(), Socket :: port(), IP :: string(), Port :: integer()) ->
  noreplay.

-callback on_client_data(Transport :: module(), Socket :: port(), Cmd :: integer(), InfoBin :: any()) ->
  noreplay.

-callback on_disconnected(Socket :: port(), Reason :: string()) ->
  noreplay.