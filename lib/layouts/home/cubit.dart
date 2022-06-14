
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layouts/home/states.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat/chat_screen.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeCubit extends Cubit<HomeLayoutStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  int currentIndex = 0;


  List<String> titles =
  [
    'News Feed',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  List<Widget> socialScreen =
  [
    FeedScreen(),
    ChatScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  Future<void> getUserData() async
  {
    emit(GetUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId).get().then((value)
    {
      userModel = UserModel.fromJson(value.data());
      emit(GetUserSucessState());
    })
        .catchError((error){
          print(error.toString());
          emit(GetUserErrorState(error.toString()));
    });
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> postlikes = [];

  Future<void> getPosts() async
  {
    posts.clear() ;
    await FirebaseFirestore.instance.collection('posts').orderBy('dateTime',descending: true).get()
        .then((value) {
      value.docs.forEach((element)
      {
        posts.add(PostModel.fromJson(element.data()));
      });
           Timer(Duration(seconds: 1), () {
             emit(GetPostsSucessState());
           });
    })
        .catchError((error) {
          emit(GetPostsErrorState(error.toString()));
          print(error.toString());
    });
  }


  changeScreen(int index)
  {
    if (index==1)
      getUsers();
    if (index==2)
      emit(NewPost());
    else {
      currentIndex = index;
      emit(ChangeScreen());
    }
  }

  File? profileImage;
  final picker = ImagePicker();

  Future <void> getProfileImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      emit(ProfilePickedSucessState());
    } else {
      print('no image selecteed');
      emit(ProfilePickedErrorState());
    }
  }


  File? coverImage;
  Future <void> getCoverImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null)
    {
      coverImage = File(pickedFile.path);
      emit(CoverPickedSucessState());
    } else {
      print('no image selecteed');
      emit(CoverPickedErrorState());
    }
  }

  String? profileImageURL;

  void uploadProfileImage(
  {
    required String name,
    required String bio,
    required String phone,
}
      )
  {
    emit(UploadProfileImageLoading());
    firebase_storage.FirebaseStorage.instance
    .ref()// عشان يدخل جوه الstorage
    .child('usersImages/${Uri.file(profileImage!.path).pathSegments.last}') // هيتحرك ازاي جوه ومسار الصورة
    .putFile(profileImage!)
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        profileImageURL = value;
        updateUser(
            name: name,
            bio: bio,
            phone: phone,
          image: value,
        );
      }
      ).catchError((onError){
        emit(UploadProfileImageError());
      });
    }).catchError((onError) {
      emit(UploadProfileImageError());
    }); // ابدأ الرفع
  }

  String? coverImageURL;

  void uploadCoverImage(
  {
    required String name,
    required String bio,
    required String phone,
}
      )
  {
    emit(UploadCoverImageLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()// عشان يدخل جوه الstorage
        .child('usersImages/${Uri.file(coverImage!.path).pathSegments.last}') // هيتحرك ازاي جوه ومسار الصورة
        .putFile(coverImage!) // ابدأ الرفع
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        coverImageURL = value;
        updateUser(
            name: name,
            bio: bio,
            phone: phone,
          cover: value,
        );
      }
      ).catchError((onError){
        emit(UploadCoverImageError());
      });
    }).catchError((onError) {
      emit(UploadCoverImageError());
    });
  }

//   void updateUserImages({
//   required String name,
//     required String bio,
//     required String phone
// })
//   {
//     if (coverImage!=null) {
//       uploadCoverImage(name,bio,phone);
//     }
//     else if (profileImage!=null) {
//       uploadProfileImage();
//       updateUser(name: name, bio: bio, phone: phone);
//     } else if (coverImage!=null && profileImage!=null)
//       {
//         uploadCoverImage(name,bio,phone);
//         uploadProfileImage();
//         updateUser(name: name, bio: bio, phone: phone);
//       } else updateUser(name: name, bio: bio, phone: phone);
//
//   }

  void updateUser(
  {
    required String name,
    required String bio,
    required String phone,
    String? image,
    String? cover,
}
      )
  {
    emit(UpdateUserLoading());

    UserModel model = UserModel(
      name: name,
      phone: phone,
      email: userModel?.email,
      cover: cover??userModel!.cover,
      image: image??userModel!.image,
      uId: userModel?.uId,
      isEmailVerified: false,
      bio: bio,
    );
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.uId)
        .update(model.toJson())
        .then((value)
    {
      getUserData();
    }
    ).catchError((onError) {
      emit(UpdateUserError());
    });
  }

  File? postImage;
  Future <void> getPostImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSucessState());
    } else {
      print('no image selecteed');
      emit(PostImagePickedErrorState());
    }
  }

  File? chatImage;
  Future <void> getChatImage() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null)
    {
      chatImage = File(pickedFile.path);
      emit(PostImagePickedSucessState());
    } else {
      print('no image selecteed');
      emit(PostImagePickedErrorState());
    }
  }

  void removePostImage()
  {
    postImage = null;
    emit(PostImageRemovedState());
  }

  void uploadPostImage({
    required String dateTime,
    required String postText,
}
      )
  {
    emit(CreateNewPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()// عشان يدخل جوه الstorage
        .child('postImages/${Uri.file(postImage!.path).pathSegments.last}') // هيتحرك ازاي جوه ومسار الصورة
        .putFile(postImage!) // ابدأ الرفع
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        createPost(
            dateTime: dateTime,
            postText: postText,
            postImage:value, // value = url for image that has been uploading
        );
      }
      ).catchError((onError){
        emit(CreateNewPostErrorState());
      });
    }).catchError((onError) {
      emit(CreateNewPostErrorState());
    });
  }

  void createPost(
      {
        required String dateTime,
        required String postText,
        String? postImage,

      }
      )
  {
    emit(CreateNewPostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      postText: postText,
      postImage: postImage??'',
      postId: null,
      postLikes: [],
      postComments: [],
    );
    String postId = '' ;
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toJson())
        .then((value)
    {
      postId = value.id ;
      FirebaseFirestore.instance.collection('posts').doc(value.id).update({'postId':value.id}).then((value) {
        model.postId = postId ;
        print(postId);
      });
      emit(CreateNewPostSucessState());
    }
    ).catchError((onError) {
      emit(CreateNewPostErrorState());
    });
  }

  // void likePost(String postId)
  // {
  //   emit(LikePostLoadingState());
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('likes')
  //       .doc(userModel!.uId)
  //       .set({
  //     "like":true
  //   })
  //       .then((value)
  //           {
  //             emit(LikePostSucessState());
  //           }
  //           )
  //       .catchError((error){
  //         emit(LikePostErrorState(error));
  //   });
  // }

   // checkLike(String postId)
   // {
   //  FirebaseFirestore.instance
   //      .collection('posts')
   //      .doc(postId)
   //       .collection('likes')
   //      .doc(userModel!.uId)
   //      .get().then((value) {
   //      if(value.data()?['like']!=null) {
   //        FirebaseFirestore.instance
   //            .collection('posts')
   //            .doc(postId)
   //            .collection('likes')
   //            .doc(userModel!.uId)
   //            .delete();
   //    }
   //      else likePost(postId);
   //  });
   // }

  void commentPost(String postId,String comment)
  {
    emit(CommentsPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uId)
        .set({
      'comment':comment
    })
        .then((value)
    {
      emit(CommentsPostSucessState());
    }
    )
        .catchError((error){
      emit(CommentsPostErrorState(error));
    });
  }

  List<UserModel> users = [];

  void getUsers()
  {
    users=[];
    FirebaseFirestore.instance
        .collection('users')
        .get().then((value) {
      value.docs.forEach((element)
      {
        if(element.data()['uId']!=userModel!.uId)
          users.add(UserModel.fromJson(element.data()));
      });
      emit(GetAllUsersSucessState());
    })
        .catchError((error) {
      emit(GetAllUsersErrorState(error.toString()));
    });
  }
  

  void sendMessage({
  required String receiverId,
    required String text,
    required String dateTime,
})
  {
    ChatModel model = ChatModel(
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel!.uId,
      text: text,
    );
    // save message in sender chats
    FirebaseFirestore.instance
    .collection('users')
    .doc(uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toJson())
    .then((value) {
      emit(SendMessageSucessState());
    })
    .catchError((onError){
      emit(SendMessageErrorState());
    });

    //save message in receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SendMessageSucessState());
    })
        .catchError((onError)
    {
      emit(SendMessageErrorState());
    });

  }

  List<ChatModel> messages = [];

  void getMessages({
  required String receiverId
})
  {
    emit(GetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
         .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages.clear();
          event.docs.forEach((element)
          {
            messages.add(ChatModel.fromJson(element.data()));
          });
          emit(GetMessageSucessState());
    });
  }
 // List<ChatModel> lastMessage = [];
 //  void getLastMessage({
 //    required String receiverId
 //  })
 //  {
 //    emit(GetMessageLoadingState());
 //    FirebaseFirestore.instance
 //        .collection('users')
 //        .doc(uId)
 //        .collection('chats')
 //        .doc(receiverId)
 //        .collection('messages')
 //        .orderBy('dateTime',descending: true)
 //        .snapshots()
 //       .first.then((value) {
 //      lastMessage.clear();
 //      value.docs.forEach((element)
 //      {
 //        lastMessage.add(ChatModel.fromJson(element.data()));
 //      });
 //      print(lastMessage[0].text);
 //      emit(GetMessageSucessState());
 //    });
 //  }


  List likesUser = [];


  List<String> postLikesUID = []  ;
  Future<void> getPostLikes (String? postID) async{
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID!)
        .get().then((value) {
      postLikesUID = List<String>.from(value.data()!['postLikes']); //السطر ده مهم
      print('this post likes are : $postLikesUID');
    });
  }

  void likeUnlikePost (String? postID){
    print(postID);
    getPostLikes(postID).then((value) {
      postLikesUID.contains(uId) ? unlike(postID!) : like(postID!); // هل تحتوي علي ال id الخاص باليوزر
    });
  }

  void like (String postID){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({'postLikes':FieldValue.arrayUnion([uId])})
        .then((value) {


      posts.forEach((element) {
        if(element.postId == postID)
          element.postLikes.add(uId.toString());
      });
      
      //getPosts();
      emit(LikePostSucessState());
    })
        .catchError((error){
      print(error.toString());
      emit(LikePostErrorState(error));
    });
  }

  void unlike (String postID){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({'postLikes':FieldValue.arrayRemove([uId])})

        .then((value) {
      // getPostLikes(postID);
      posts.forEach((element) {
        if(element.postId == postID)
          element.postLikes.remove(uId.toString());
      });
      
      //  getPosts();
      emit(UnLikePostSucessState());
    })
        .catchError((error){
      print(error.toString());
      emit(UnLikePostErrorState(error));
    });
  }

  List<UserModel>? usersWhoLikes =[] ;
  Future<void> getPostUsersLikes (String? postID) async{
    usersWhoLikes!.clear();
    emit(GetLikedUsersLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID!)
        .get().then((value) {
      List<String>.from(value.data()!['postLikes']).forEach((element) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(element)
            .get().then((value)  {
          usersWhoLikes!.add(UserModel.fromJson(value.data()));
          emit(GetLikedUsersSucessState());
        });
      });


    });
  }

  void addComment ({
    required String postID,
    required CommentModel comment
  }){
    emit(CommentsPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({'postComments':FieldValue.arrayUnion([comment.toJson()])})

        .then((value) {
      posts.forEach((element) {
        if(element.postId == postID)
          element.postComments.add(comment);
      });
      emit(CommentsPostSucessState());
    })
        .catchError((error){
      print(error.toString());
      emit(CommentsPostErrorState(error));
    });
  }

  List<PostModel> searchResult = [] ;
  Future<void> search (String text) async {
    emit(SearchLoadingState());
    searchResult.clear();

    posts.forEach((element) {
      if(element.postText!.contains(text))
        searchResult.add(element);
    });

    emit(SearchSucessState());
  }

  // List<UserModel>? usersWhoLikes =[] ;
  // Future<void> getPostUsersLikes () async{
  //   usersWhoLikes!.clear();
  //   emit(GetUsersLikeLoadingState());
  //   await FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc('CLJxTGiRvHFJTOqLXF1Y')
  //       .get().then((value) {
  //     List<String>.from(value.data()!['likes']).forEach((element) {
  //
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(element)
  //           .get().then((value)  {
  //         usersWhoLikes!.add(UserModel.fromJson(value.data()));
  //         print(usersWhoLikes!.length);
  //         emit(GetUsersLikeSucessState());
  //       });
  //     });
  //
  //
  //   });
  // }

}