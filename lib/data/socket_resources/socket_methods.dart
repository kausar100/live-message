import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/data/socket_resources/socket_constant.dart';
import 'package:live_message/screens/home_screen.dart';
import 'package:live_message/screens/login_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void registerUser(String name, String email, String password) {
    _socketClient.emit(IOConstant.registerEmitter,
        {'name': name, 'email': email, 'password': password});
  }

  void clearDB() {
    _socketClient.emit("onClearDB");
  }

  void loginUser(String email, String password) {
    _socketClient
        .emit(IOConstant.loginEmitter, {'email': email, 'password': password});
  }

  void requestSent(String senderId, String receiverId) {
    _socketClient.emit(IOConstant.requestSentEmitter,
        {senderId: senderId, receiverId: receiverId});
  }

  void requestAccept(String senderId, String receiverId) {
    _socketClient.emit(IOConstant.requestAcceptEmitter,
        {senderId: senderId, receiverId: receiverId});
  }

  void messageSent(String text) {
    _socketClient.emit(IOConstant.messageSentEmitter,
        {"senderSocketID": _socketClient.id, "message": text});
  }

  // LISTENERS
  void onRegistrationSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.registerSuccessListener, (data) {
      print("onRegistrationSuccessListener $data");
      showSnackBar(context, "User registration completed successfully!");
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
      //go to home page
      Navigator.pushNamed(context, HomeScreen.routeName);
    });
  }

  void onRequestUserListener(BuildContext context) {
    _socketClient.on(IOConstant.onUserRequestListener, (data) {
      print("onRequestUserListener $data");
    });
  }

  void onActiveUserListener(BuildContext context) {
    _socketClient.on(IOConstant.onActiveUserListener, (data) {
      print("onActiveUserListener $data");
      //save data
      final activeUsers = Person.jsonToPersonList(data);
      print("before:" + activeUsers.toString());
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateActiveUser(activeUsers);
    });
  }

  void onRequestSentSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.requestSentSuccessListener, (data) {
      print("onRequestSentSuccessListener $data");
    });
  }

  void onRequestAcceptSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.requestAcceptSuccessListener, (data) {
      print("onRequestAcceptSuccessListener $data");
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
}
