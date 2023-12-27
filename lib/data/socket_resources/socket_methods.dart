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
    _socketClient.emit(IOConstant.onFetchActiveUserEmitter, id);
  }

  void loginUser({required String email, required String password}) {
    _socketClient
        .emit(IOConstant.loginEmitter, {'email': email, 'password': password});
  }

  void logoutUser({required String id}) {
    _socketClient.emit(IOConstant.logoutEmitter, id);
  }

  void updateEngagedStatus({required String id}) {
    _socketClient.emit(IOConstant.onUpdateEngagedStatusEmitter, id);
  }

  void leaveConversation(
      {required String currentUserId, required String otherPersonId}) {
    _socketClient.emit(IOConstant.leaveConversationEmitter,
        {"senderId": currentUserId, "receiverId": otherPersonId});
  }

  void requestSent(
      {required BuildContext context,
      required String senderId,
      required Person receiver}) {
    _socketClient.emit(IOConstant.requestSentEmitter,
        {"senderId": senderId, "receiverId": receiver.id});
  }

  void requestAccept({required String senderId, required String receiverId}) {
    _socketClient.emit(IOConstant.requestAcceptEmitter,
        {"senderId": senderId, "receiverId": receiverId});
  }

  void requestHold({required String senderId, required String receiverId}) {
    _socketClient.emit(IOConstant.requestPendingEmitter,
        {"senderId": senderId, "receiverId": receiverId});
  }

  void messageSent({required Message message}) {
    _socketClient.emit(IOConstant.messageSentEmitter, {
      "senderId": message.senderID,
      "receiverId": message.receiver,
      "message": message.text
    });
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

      //subscribe to own id for for messages
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

  void onLeaveConversationSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.onLeaveConversationSuccessListener, (msg) {
      print("onLeaveConversationSuccessListener $msg");

      _clearAndLeaveChat(context);
    });
  }

  void onLeaveConversationNotifyListener(BuildContext context) {
    _socketClient.on(IOConstant.onLeaveConversationNotifyListener, (msg) {
      print("onLeaveConversationNotifyListener $msg");

      showWaitingDialog(
          context: context,
          text:
              "Other person exit from conversation. All message history will be deleted. Your about to leave this conversation.",
          showCancel: false,
          onCancel: () {
            //can't do these
          },
          onConfirm: () {
            _clearAndLeaveChat(context);
          });
    });
  }

  void _clearAndLeaveChat(BuildContext context) {
    final provider = Provider.of<RoomDataProvider>(context, listen: false);

    //subscribe to room again
    // _subscribeToRoom(provider.currentUser!.id!);

    //update engaged status -> false
    updateEngagedStatus(id: provider.currentUser!.id!);

    //clear chat history
    provider.clearChatHistory();

    //change active list
    final userList = provider.userList;
    userList.add(provider.requestUser!);
    provider.updateActiveUser(userList);

    //change requested user
    final requestedUserList = provider.requestedUserList;
    requestedUserList
        .removeWhere((p) => p.email == provider.requestUser!.email);
    provider.updateRequestedUser(requestedUserList);

    //clear request user
    provider.clearRequestUser();

    //goto home screen
    Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
  }

  void onRequestUserListener(BuildContext context) {
    _socketClient.on(IOConstant.onUserRequestListener, (data) {
      print("onRequestUserListener $data");

      final provider = Provider.of<RoomDataProvider>(context, listen: false);

      final sender = Person.fromJson(data);

      final requestedList = provider.requestedUserList;
      requestedList.add(sender);

      provider.updateRequestedUser(requestedList);

      showWaitingDialog(
          context: context,
          text: "${sender.name} is waiting for your confirmation!",
          onCancel: () {
            //send hold request
            requestHold(
                senderId: sender.id!, receiverId: provider.currentUser!.id!);
          },
          onConfirm: () {
            //accept request
            requestAccept(
                senderId: sender.id!, receiverId: provider.currentUser!.id!);

            //save request user
            provider.saveRequestUser(sender);

            //update engaged status
            updateEngagedStatus(id: provider.currentUser!.id!);

            //go to message screen
            Navigator.pushNamed(context, MessageScreen.routeName,
                arguments: sender);
          });
    });
  }

  void disconnectSocket() {
    SocketClient.instance.socket?.disconnect();
  }

  void onLogoutSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.logoutSuccessListener, (data) {
      print("onLogoutSuccessListener $data");

      final provider = Provider.of<RoomDataProvider>(context, listen: false);

      final logoutPerson = Person.fromJson(data);

      //myself
      if (logoutPerson.id! == provider.currentUser!.id!) {
        _socketClient.emit("leaveSocket", provider.currentUser!.id!);
        //goto login screen
        Navigator.popUntil(context, ModalRoute.withName(LoginScreen.routeName));
      } else {
        //remove from request list
        final requestedPersonList = provider.requestedUserList;
        requestedPersonList.removeWhere((p) => p.id == logoutPerson.id!);

        //update requested user
        provider.updateRequestedUser(requestedPersonList);

        //fetch active list
        fetchActiveUser(provider.currentUser!.id!);
      }
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

      final provider = Provider.of<RoomDataProvider>(context, listen: false);

      //not me
      if (newUser.email != provider.currentUser!.email) {
        //fetch current active user
        final activeUsers = provider.userList;

        final alreadyExist = activeUsers
            .where((element) => element.email == newUser.email)
            .toList();

        if (alreadyExist.isNotEmpty) {
          //do nothing
        } else {
          activeUsers.add(newUser);
          provider.updateActiveUser(activeUsers);
        }
      } else {
        print('update not needed');
      }
    });
  }

  //SENT REQUEST SUCCESS
  void onRequestSentSuccessListener(BuildContext context) {
    _socketClient.on(IOConstant.requestSentSuccessListener, (chatID) {
      print("onRequestSentSuccessListener $chatID");

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

      //save request user
      final receiver = Person.fromJson(data);
      Provider.of<RoomDataProvider>(context, listen: false)
          .saveRequestUser(receiver);

      //pop dialog and goto message screen
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
      Navigator.pushNamed(context, MessageScreen.routeName,
          arguments: receiver);
    });
  }

  void onRequestPendingListener(BuildContext context) {
    _socketClient.on(IOConstant.requestPendingListener, (data) {
      print("onRequestPendingListener $data");

      final receiver = Person.fromJson(data);

      final provider = Provider.of<RoomDataProvider>(context, listen: false);

      final requestedList = provider.requestedUserList;
      requestedList.add(receiver);

      //add new request user
      provider.updateRequestedUser(requestedList);

      //pop dialog screen
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
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
