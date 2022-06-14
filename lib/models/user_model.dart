class UserModel
{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? bio;
  String? image;
  String? cover;
  bool? isEmailVerified;
  UserModel(
      {
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.isEmailVerified,
    this.bio,
    this.image,
    this.cover
      });

  UserModel.fromJson(Map<String,dynamic>? json)
  {
    email = json!['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    bio = json['bio'];
    cover = json['cover'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String,dynamic> toJson()
  {
    return
      {
        'name':name,
        'email':email,
        'phone':phone,
        'image':image,
        'uId':uId,
        'cover':cover,
        'bio':bio,
        'isEmailVerified':isEmailVerified,
      };
  }
}