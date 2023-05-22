class MessageModel {
    String? senderId;
    String? receiverId;
    String? dateTime;
    String? text;

  MessageModel({
  this.senderId,
  this.receiverId,
  this.dateTime,
  this.text,
});

MessageModel.fromJson(Map<String, dynamic> document) {
  senderId = document['senderId'];
  receiverId = document['receiverId'];
  dateTime = document['dateTime'];
  text = document['text'];
}

Map<String, dynamic> toMap() {
  return {
    'senderId': senderId,
    'receiverId': receiverId,
    'dateTime': dateTime,
    'text': text,
  };
}
}