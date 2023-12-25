import 'package:flutter/material.dart';
import 'package:live_message/data/model/message.dart';
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

  void logoutUser({required String id}) {
    _socketClient
        .emit(IOConstant.logoutEmitter, id);
  }

  void updateEngagedStatus({required String id}) {
    _socketClient.emit(IOConstant.onUpdateEngagedStatusEmitter, id);
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

  void messageSent({required String chatId, required Message message}) {
    _socketClient.emit(IOConstant.messageSentEmitter, {"chatId":chatId, "senderId": message.senderID, "receiverId": message.receiver, "message": message.text});
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

      //fetch active user
      fetchActiveUser(user.id!);

      //go to home page
      Navigator.pushNamed(context, HomeScreen.routeName);
    });
  }

  void onUpdateEngagedSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.onUpdateEngagedStatusSuccessListener, (data) {
      print("onUpdateEngagedStatusSuccessListener $data");
      //save data
      final user = Person.fromJson(data);
      Provider.of<RoomDataProvider>(context, listen: false).updateUser(user);
    });
  }

  void onRequestUserListener(BuildContext context) {
    _socketClient.on(IOConstant.onUserRequestListener, (data) {
      print("onRequestUserListener $data");

      final provider = Provider.of<RoomDataProvider>(context, listen: false);

      //set chat id
      provider.setChatId = data['chatID'];

      final senderInfo = data['sender'];
      List<Person> users = [];
      final sender = Person.fromJson(senderInfo);
      users.add(sender);

      showWaitingDialog(
          context: context,
          text: "${sender.name} is waiting for your confirmation!",
          onCancel: () {
            Provider.of<RoomDataProvider>(context, listen: false)
                .updateRequestedUser(users);

          },
          onConfirm: () {
            Provider.of<RoomDataProvider>(context, listen: false)
                .updateRequestedUser(users);

            //accept request
            requestAccept(
                senderId: sender.id!,
                receiverId: provider.currentUser!.id!,
                chatId: provider.chatID!);


            //update engaged status
            updateEngagedStatus(id:  provider.currentUser!.id!);

            //go to message screen
            Navigator.pushNamed(context, MessageScreen.routeName,
                arguments: sender);
          });
    });
  }

  void disconnectSocket() {
    SocketClient.instance.socket?.disconnect();
  }

  void onLogoutSuccessListener(BuildContext context){
    _socketClient.on(IOConstant.logoutSuccessListener, (data) {
      print("onLogoutSuccessListener $data");

      //remove from request list
      final logoutPerson = Person.fromJson(data);
      final requestedPersonList = Provider.of<RoomDataProvider>(context, listen: false).requestedUserList;

      final alreadyExist = requestedPersonList.where((element) => element.email == logoutPerson.email).toList();

      if(requestedPersonList.isNotEmpty && alreadyExist.isNotEmpty){
        final newList = requestedPersonList.where((p) => p.email != logoutPerson.email).toList();
        Provider.of<RoomDataProvider>(context, listen: false)
            .updateRequestedUser(newList);
      }
      final me = Provider.of<RoomDataProvider>(context, listen: false).currentUser!;
      //fetch active list
      fetchActiveUser(me.id!);

    });
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

  void onNewLoginUserListener(BuildContext context) {
    _socketClient.on(IOConstant.onNewUserLoginListener, (data) {
      print("onNewLoginUserListener $data");

      //new user login
      final newUser = Person.fromJson(data);

      final me =
          Provider.of<RoomDataProvider>(context, listen: false).currentUser!;

      //not me
      if (newUser.email != me.email) {
        //fetch current active user
        final activeUsers =
            Provider.of<RoomDataProvider>(context, listen: false).userList;

        final alreadyExist = activeUsers.where((element) => element.email == newUser.email).toList();

        if (alreadyExist.isNotEmpty) {
          //remove the newuser
          final newList = activeUsers.where((p) => p.email != newUser.email).toList();

          //add with new info
          newList.add(newUser);
          Provider.of<RoomDataProvider>(context, listen: false)
              .updateActiveUser(activeUsers);

        } else {
          activeUsers.add(newUser);
          //update active users with new user
          Provider.of<RoomDataProvider>(context, listen: false)
              .updateActiveUser(activeUsers);
        }
      } else {
        print('update not needed');
      }
    });
  }

  //SENT REQUEST AND UPDATE OWN INFO WITH CHAT ID
  void onRequestSentSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.requestSentSuccessListener, (chatID) {
      print("onRequestSentSuccessListener $chatID");

      //save data
      Provider.of<RoomDataProvider>(context, listen: false).setChatId = chatID;

      showProgressDialog(context, "Waiting for accepting request...");
    });
  }

  void onRequestAcceptSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.requestAcceptSuccessListener, (data) {
      print("onRequestAcceptSuccessListener $data");

      final me =
          Provider.of<RoomDataProvider>(context, listen: false).currentUser!;

      //update status
      updateEngagedStatus(id: me.id!);

      //dismiss waiting view, show message screen
      final receiver = Person.fromJson(data);
      Navigator.pushNamed(context, MessageScreen.routeName,
          arguments: receiver);
    });
  }

  void onMessageSentSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.messageSentSuccessListener, (data) {
      print("onMessageSentSuccessListener $data");

      final msg = Message.fromJson(data);
      Provider.of<RoomDataProvider>(context, listen: false).addNewMessage(msg);

    });
  }

  void onMessageReceiveSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.messageReceiveSuccessListener, (data) {
      print("onMessageReceiveSuccessListener $data");

      final msg = Message.fromJson(data);
      Provider.of<RoomDataProvider>(context, listen: false).addNewMessage(msg);
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
