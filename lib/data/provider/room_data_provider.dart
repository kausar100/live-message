import 'package:flutter/material.dart';
import 'package:live_message/data/model/message.dart';
import 'package:live_message/data/model/person.dart';

class RoomDataProvider extends ChangeNotifier {
  Person? _user;
  Person? _requestUser;
  List<Person> _activeUserList = [];
  List<Person> _requestUserList = [];
  final List<Message> _messageList = [];

  Person? get currentUser => _user;

  Person? get requestUser => _requestUser;

  List<Person> get userList => _activeUserList;

  List<Person> get requestedUserList => _requestUserList;

  List<Message> get messages => _messageList;

  void updateUser(Person info) {
    _user = info;
    notifyListeners();
  }

  void saveRequestUser(Person info) {
    //remove request user from active list
    _activeUserList.removeWhere((p) => p.id! == info.id!);
    //save user
    _requestUser = info;
    notifyListeners();
  }

  void clearRequestUser() {
    _requestUser = null;
    notifyListeners();
  }

  void updateActiveUser(List<Person> data) {
    _activeUserList = data;
    notifyListeners();
  }

  void updateRequestedUser(List<Person> data) {
    _requestUserList = data;
    notifyListeners();
  }

  void updatedEngagedStatus() {
    var now = currentUser;
    now!.isEngaged = true;

    _user = now;
    notifyListeners();
  }

  void addNewMessage(Message msg) {
    _messageList.add(msg);
    notifyListeners();
  }

  void clearChatHistory() {
    _messageList.clear();
    notifyListeners();
  }
}
