import 'package:social_app/models/user_model.dart';

class CommentModel
{
  UserModel? user;
  String? text;
  String? dateTime;
  String? commentId;
  CommentModel({
    this.user,
    this.text,
    this.dateTime,
    this.commentId,
});
  CommentModel.fromJson(Map<String,dynamic>? json)
  {
    user = UserModel.fromJson(json!['user']);
    text = json['text'];
    dateTime = json['dateTime'];
    commentId = json['commentId'];
  }

  Map<String,dynamic> toJson() {
    return
      {
        'user': user!.toJson(),
        'text': text,
        'dateTime': dateTime,
        'commentId': commentId,
      };
  }
}