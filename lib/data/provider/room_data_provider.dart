import 'package:flutter/material.dart';
import 'package:live_message/data/model/message.dart';
import 'package:live_message/data/model/person.dart';

class RoomDataProvider extends ChangeNotifier {
  String? _chatID;
  Person? _user;
  Person? _requestUser;
  List<Person> _activeUserList = [];
  List<Person> _requestUserList = [];
  List<Message> _messageList = [];

  Person? get currentUser => _user;
  Person? get requestUser => _requestUser;

  String? get chatID => _chatID;

  set setChatId(String chatId) => _chatID = chatId;

  List<Person> get userList => _activeUserList;
  List<Person> get requestedUserList => _requestUserList;
  List<Message> get messages => _messageList;


  void updateUser(Person info) {
    _user = info;
    notifyListeners();
  }

  void saveRequestUser(Person info) {
    //remove request user from active list
    _activeUserList = userList.where((p)=>p.id! != info.id!).toList();

    //save user
    _requestUser = info;
    notifyListeners();
  }

  void updateActiveUser(List<Person> data) {
    _activeUserList = data;
    print(userList.length.toString());
    notifyListeners();
  }

  void updateRequestedUser(List<Person> data) {
    _requestUserList = data;
    print(requestedUserList.length.toString());
    notifyListeners();
  }

  void updatedEngagedStatus() {
    var now = currentUser;
    now!.isEngaged = true;

    _user = now;
    notifyListeners();
  }

  void addNewMessage(Message msg){
    _messageList.add(msg);
    notifyListeners();

  }
}
