import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/data/socket_resources/socket_constant.dart';
import 'package:live_message/screens/home_screen.dart';
import 'package:live_message/screens/login_screen.dart';
import 'package:live_message/screens/message_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void registerUser(
      {required String name, required String email, required String password}) {
    _socketClient.emit(IOConstant.registerEmitter,
        {'name': name, 'email': email, 'password': password});
  }

  void clearDB() {
    _socketClient.emit("onClearDB");
  }

  void fetchActiveUser(String id) {
    _socketClient.emit(IOConstant.onFetchActiveUserEmitter, {'id': id});
  }

  void loginUser({required String email, required String password}) {
    _socketClient
        .emit(IOConstant.loginEmitter, {'email': email, 'password': password});
  }

  void requestSent(
      {required BuildContext context,
      required String senderId,
      required Person receiver}) {
    _socketClient.emit(IOConstant.requestSentEmitter,
        {"senderId": senderId, "receiverId": receiver.id});

    //save request user
    Provider.of<RoomDataProvider>(context, listen: false)
        .saveRequestUser(receiver);
  }

  void requestAccept(
      {required String senderId,
      required String receiverId,
      required String chatId}) {
    _socketClient.emit(IOConstant.requestAcceptEmitter,
        {"senderId": senderId, "receiverId": receiverId, "chatId": chatId});
  }

  void messageSent(String text) {
    _socketClient.emit(IOConstant.messageSentEmitter,
        {"senderSocketID": _socketClient.id, "message": text});
  }

  void _subscribeToRoom(String roomId) {
    //user roomid by own user id
    _socketClient.emit(IOConstant.joinRoomEmitter, roomId);
  }

  // LISTENERS
  void onRegistrationSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.registerSuccessListener, (data) {
      print("onRegistrationSuccessListener $data");
      // goto login page
      Navigator.pushNamed(context, LoginScreen.routeName);
    });
  }

  void onLoginSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.loginSuccessListener, (data) {
      print("onLoginSuccessListener $data");
      //save data
      final user = Person.fromJson(data);
      Provider.of<RoomDataProvider>(context, listen: false).updateUser(user);

      //subscribe to own room for messages
      _subscribeToRoom(user.id!);

      //go to home page
      Navigator.pushNamed(context, HomeScreen.routeName);
    });
  }

  void onRequestUserListener(BuildContext context) {
    _socketClient.on(IOConstant.onUserRequestListener, (data) {
      print("onRequestUserListener $data");

      //save data
      final info =
          Provider.of<RoomDataProvider>(context, listen: false).currentUser!;

      info.chatID = data['chatID'];
      Provider.of<RoomDataProvider>(context, listen: false).updateUser(info);

      final senderInfo = data['sender'];
      List<Person> users = [];
      final sender = Person.fromJson(senderInfo);
      users.add(sender);

      showWaitingDialog(context,"${sender.name} is waiting for your confirmation!", (ctx) {
        Provider.of<RoomDataProvider>(context, listen: false)
            .updateRequestedUser(users);
        //accept request
        requestAccept(senderId: sender.id!, receiverId: info.id!, chatId: info.chatID!);

        //update status
        Provider.of<RoomDataProvider>(context, listen: false)
            .updatedEngagedStatus();

        //dismiss dialog
        Navigator.of(ctx).pop();

        //go to message screen
        Navigator.pushNamed(context, MessageScreen.routeName, arguments: sender);
      });
    });
  }

  void disconnectSocket() {
    SocketClient.instance.socket?.disconnect();
  }

  void onActiveUserListener(BuildContext context) {
    _socketClient.on(IOConstant.onActiveUserListener, (data) {
      print("onActiveUserListener $data");
      //save data
      final activeUsers = Person.jsonToPersonList(data);
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateActiveUser(activeUsers);
    });
  }

  //SENT REQUEST AND UPDATE OWN INFO WITH CHAT ID
  void onRequestSentSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.requestSentSuccessListener, (data) {
      print("onRequestSentSuccessListener $data");

      //save data
      final info =
          Provider.of<RoomDataProvider>(context, listen: false).currentUser!;
      info.chatID = data;

      Provider.of<RoomDataProvider>(context, listen: false).updateUser(info);

      showProgressDialog(context,"Waiting for accepting request...");

    });
  }

  void onRequestAcceptSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.requestAcceptSuccessListener, (msg) {
      print("onRequestAcceptSuccessListener $msg");
      //update status
      Provider.of<RoomDataProvider>(context, listen: false)
          .updatedEngagedStatus();

      //dismiss waiting view, show message screen
      final receiver =
          Provider.of<RoomDataProvider>(context, listen: false).requestUser;
      Navigator.pushNamed(context, MessageScreen.routeName,
                arguments: receiver);
    });
  }

  void onMessageSentSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.messageSentSuccessListener, (data) {
      print("onMessageSentSuccessListener $data");
    });
  }

  void onMessageReceiveSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.messageReceiveSuccessListener, (data) {
      print("onMessageReceiveSuccessListener $data");
    });
  }

  void onErrorOccuredListener(BuildContext context) {
    _socketClient.on(IOConstant.errorOccurredListener, (data) {
      showSnackBar(context, data);
    });
  }

  void onUserBusyListener(BuildContext context) {
    _socketClient.on(IOConstant.userBusyListener, (data) {
      showSnackBar(context, data);
    });
  }
}
