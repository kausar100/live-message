class Person {
  String? id;
  String? name;
  String? email;
  String? socketID;
  String? chatID;
  bool? isActive;
  bool? isEngaged;

  Person(
      {this.id,
      this.name,
      this.email,
      this.socketID,
      this.chatID,
      this.isActive,
      this.isEngaged});

  Person.fromJson(Map<String, dynamic> json) {
    id = json["_id"] ?? "";
    name = json["name"] ?? "";
    email = json["email"] ?? "";
    socketID = json["socketID"] ?? "";
    chatID = json["chatID"] ?? "";
    isActive = json["isActive"] ?? true;
    isEngaged = json["isEngaged"] ?? false;
  }

  Person copyWith(Person p) => Person(
      id: p.id ?? id,
      name: p.name ?? name,
      email: p.email ?? email,
      socketID: p.socketID ?? socketID,
      chatID: p.chatID ?? chatID,
      isActive: p.isActive ?? isActive,
      isEngaged: p.isEngaged ?? isEngaged);

  static List<Person> jsonToPersonList(List<dynamic> json) {
    List<Person> userList = [];

    userList = json.map((e) => Person.fromJson(e)).toList();

    return userList;
  }
}
