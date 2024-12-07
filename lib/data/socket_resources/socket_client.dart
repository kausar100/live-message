import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  Socket? socket;

  static SocketClient? _instance;

  SocketClient._init() {
    socket = io(
        'http://192.168.0.108:3000',
        // 'http://your ip address:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    //connect to socket
    socket!.connect();

    socket?.onConnect((_) => print('connect'));
    socket?.onDisconnect((_) => print('disconnect'));
  }

  static SocketClient get instance {
    _instance ??= SocketClient._init();
    return _instance!;
  }
}
