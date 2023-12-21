import 'package:flutter/material.dart';
import 'package:live_message/data/socket_resources/socket_constant.dart';
import 'package:live_message/utils/shared.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void registerUser(String name, String email, String password) {
    _socketClient.emit(
        IOConstant.registerEmitter, {'name': name, 'email': email, 'password': password});
  }

  void loginUser(String email, String password) {
    _socketClient.emit(IOConstant.loginEmitter, {'email': email, 'password': password});
  }

  // void createRoom(String nickname) {
  //   if (nickname.isNotEmpty) {
  //     _socketClient.emit('createRoom', {
  //       'nickname': nickname,
  //     });
  //   }
  // }
  //
  // void joinRoom(String nickname, String roomId) {
  //   if (nickname.isNotEmpty && roomId.isNotEmpty) {
  //     _socketClient.emit('joinRoom', {
  //       'nickname': nickname,
  //       'roomId': roomId,
  //     });
  //   }
  // }

  // void sentMessage(int index, String roomId, List<String> displayElements) {
  //   if (displayElements[index] == '') {
  //     _socketClient.emit('tap', {
  //       'index': index,
  //       'roomId': roomId,
  //     });
  //   }
  // }

  // LISTENERS
  void onRegistrationSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.registerSuccessListener, (data) {
      print("registration $data");
      // Provider.of<RoomDataProvider>(context, listen: false)
      //     .updateRoomData(room);
      // Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void onLoginSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.loginSuccessListener, (data) {
      print("login $data");
      // Provider.of<RoomDataProvider>(context, listen: false)
      //     .updateRoomData(room);
      // Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void onErrorOccuredListener(BuildContext context) {
    _socketClient.on(IOConstant.errorOccurredListener, (data) {
      showSnackBar(context, data);
    });
  }

  // void createRoomSuccessListener(BuildContext context) {
  //   _socketClient.on('createRoomSuccess', (room) {
  //     // Provider.of<RoomDataProvider>(context, listen: false)
  //     //     .updateRoomData(room);
  //     // Navigator.pushNamed(context, GameScreen.routeName);
  //   });
  // }
  //
  // void joinRoomSuccessListener(BuildContext context) {
  //   _socketClient.on('joinRoomSuccess', (room) {});
  // }
  //
  // void updateRoomListener(BuildContext context) {
  //   _socketClient.on('updateRoom', (data) {
  //     // Provider.of<RoomDataProvider>(context, listen: false)
  //     //     .updateRoomData(data);
  //   });
  // }
  //
  // void tappedListener(BuildContext context) {
  //   _socketClient.on('tapped', (data) {});
  // }
  //
  // void endGameListener(BuildContext context) {
  //   _socketClient.on('endGame', (playerData) {
  //     showGameDialog(context, '${playerData['nickname']} won the game!');
  //     Navigator.popUntil(context, (route) => false);
  //   });
  // }
}
