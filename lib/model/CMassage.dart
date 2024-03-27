class CMassage {
  String message;
  String SentByMe;
  CMassage({required this.message, required this.SentByMe});
  factory CMassage.fromJosn(Map<String, dynamic> json) {
    return CMassage(message: json["message"], SentByMe: json["SentByMe"]);
  }
}
