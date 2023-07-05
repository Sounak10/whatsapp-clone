class ChatModel {
  ChatModel({
    required this.msg,
    required this.toUID,
    required this.fromUID,
    required this.readTime,
    required this.type,
    required this.sendTime,
  });
  late final String msg;
  late final String toUID;
  late final String fromUID;
  late final String readTime;
  late final Type type;
  late final String sendTime;

  ChatModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toUID = json['toUID'].toString();
    fromUID = json['fromUID'].toString();
    readTime = json['readTime'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sendTime = json['sendTime'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toUID'] = toUID;
    data['fromUID'] = fromUID;
    data['readTime'] = readTime;
    data['type'] = type.name;
    data['sendTime'] = sendTime;
    return data;
  }
}

enum Type { text, image }
