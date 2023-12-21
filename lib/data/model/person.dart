import 'dart:convert';

class Person {
  String? name;
  String? email;
  String? socketID;
  String? chatID;
  bool? isActive;
  bool? isEngaged;

  Person(this.name, this.email, this.socketID, this.chatID, this.isActive,
      this.isEngaged);

  Person.fromJson(Map<String, dynamic> json) {
    name = json["name"] ?? "";
    email = json["email"] ?? "";
    socketID = json["socketID"] ?? "";
    chatID = json["chatID"] ?? "";
    isActive = json["isActive"] ?? true;
    isEngaged = json["isEngaged"] ?? false;
  }

  static List<Person> jsonToPersonList(List<dynamic> json) {
    List<Person> userList = [];

    userList = json.map((e) => Person.fromJson(e)).toList();

    return userList;
  }
}
