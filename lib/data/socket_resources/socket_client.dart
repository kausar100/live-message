import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  Socket? socket;

  static SocketClient? _instance;

  SocketClient._init() {
    socket = io(
        'http://192.168.0.108:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._init();
    return _instance!;
  }
}
