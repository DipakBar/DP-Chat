class Message {
  String massage_id = '';
  String sender_id = '';
  String receiver_id = '';
  String massage_date = '';
  String massage_time = '';
  String attachment = '';
  String content = '';
  // String SentByMe;
  Message({
    required this.sender_id,
    required this.receiver_id,
    required this.massage_date,
    required this.massage_time,
    required this.attachment,
    required this.content,
    // required this.SentByMe,
    this.massage_id = "0",
  });
  factory Message.fromJosn(Map<String, dynamic> json) {
    return Message(
      sender_id: json["sender_id"],
      receiver_id: json["receiver_id"],
      massage_date: json["massage_date"],
      massage_time: json["massage_time"],
      attachment: json["attachment"],
      content: json["content"],
      // SentByMe: json["SentByMe"]
    );
  }
}
