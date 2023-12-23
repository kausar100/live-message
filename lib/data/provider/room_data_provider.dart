import 'package:flutter/material.dart';
import 'package:live_message/data/model/person.dart';

class RoomDataProvider extends ChangeNotifier {
  Person? _user;
  Person? _requestUser;
  List<Person> _activeUserList = [];
  List<Person> _requestUserList = [];

  Person? get currentUser => _user;
  Person? get requestUser => _requestUser;

  List<Person> get userList => _activeUserList;
  List<Person> get requestedUserList => _requestUserList;

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
}
