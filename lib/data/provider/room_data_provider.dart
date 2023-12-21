import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';

class RoomDataProvider extends ChangeNotifier {
  Map<String, dynamic> _roomData = {};

  Person? _user;
  List<Person> _userList = [];

  Map<String, dynamic> get roomData => _roomData;

  Person? get currentUser => _user;
  List<Person> get userList => _userList;

  void updateRoomData(Map<String, dynamic> data) {
    _roomData = data;
    notifyListeners();
  }

  void updateUser(Person info) {
    _user = info;
    notifyListeners();
  }

  void updateActiveUser(List<Person> data) {
    _userList = data;
    print(userList.length.toString());
    notifyListeners();
  }
}
