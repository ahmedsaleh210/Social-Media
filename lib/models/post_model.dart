import 'package:social_app/models/comment_model.dart';

class PostModel
{
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? postText;
  String? postImage;
  String? postId;
  List<String> postLikes = [];
  List<CommentModel> postComments = [];
  PostModel(
      {
        this.name,
        this.uId,
        this.image,
        this.dateTime,
        this.postText,
        this.postImage,
        this.postId,
        required this.postLikes,
        required this.postComments,
      });

  PostModel.fromJson(Map<String,dynamic>? json)
  {
    name = json!['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    postText = json['postText'];
    postImage = json['postImage'];
    postId = json['postId'];
    postLikes = (json['postLikes'] != null ? List<String>.from(json['postLikes']) : null)!;
    json['postComments'].forEach((v) {
      if( v != null)
        postComments.add(CommentModel.fromJson(v));
    });
  }

  Map<String,dynamic> toJson()
  {
    return
      {
        'name':name,
        'image':image,
        'uId':uId,
        'dateTime':dateTime,
        'postText':postText,
        'postImage':postImage,
        'postId':postId,
        'postLikes': postLikes.map((e) => e.toString()).toList(),
        'postComments': postComments.map((e) => e.toString()).toList(),
      };
  }
}