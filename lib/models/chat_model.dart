class ChatModel {
  String? senderId ;
  String? receiverId ;
  String? dateTime ;
  String?  text;

  ChatModel({required this.senderId,required this.receiverId,required this.dateTime, required this.text});

  ChatModel.fromJson(Map<String,dynamic>? json){
    senderId = json!['senderID'];
    receiverId = json['receiverID'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderID'] = senderId ;
    data['receiverID'] = receiverId ;
    data['dateTime'] = dateTime ;
    data['text'] = text ;
    return data ;
  }
}