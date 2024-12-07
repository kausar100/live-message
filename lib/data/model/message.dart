class Message {
  String? senderID;
  String? receiver;
  String? text;
  String? createdAt;

  Message({required this.senderID, this.receiver="", required this.text, this.createdAt = ""});

  static Map<String, dynamic> toJson(Message msg) => {
        "sender": msg.senderID ?? "",
        "receiver": msg.receiver ?? "",
        "text": msg.text ?? "",
        "createdAt": msg.createdAt ?? ""
      };


  Message.fromJson(Map<String, dynamic> json) {
    senderID = json["senderID"] ?? "";
    text = json["text"] ?? "";
    createdAt = json["createdAt"] ?? "";
  }

}
