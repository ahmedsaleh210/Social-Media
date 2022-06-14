abstract class HomeLayoutStates {}


class HomeInitialState extends HomeLayoutStates {}

class ChangeScreen extends HomeLayoutStates {}

//home states
class GetUserSucessState extends HomeLayoutStates {}

class GetUserLoadingState extends HomeLayoutStates {}

class GetUserErrorState extends HomeLayoutStates
{
  final String error;
  GetUserErrorState(this.error);
}

//chat states

class GetAllUsersSucessState extends HomeLayoutStates {}

class GetAllUsersLoadingState extends HomeLayoutStates {}

class GetAllUsersErrorState extends HomeLayoutStates
{
  final String error;
  GetAllUsersErrorState(this.error);
}


//posts


class NewPost extends HomeLayoutStates {}

class GetPostsSucessState extends HomeLayoutStates {}

class GetPostsLoadingState extends HomeLayoutStates {}

class GetPostsErrorState extends HomeLayoutStates
{
  final String error;
  GetPostsErrorState(this.error);
}

class LikePostSucessState extends HomeLayoutStates {}

class LikePostLoadingState extends HomeLayoutStates {}

class LikePostErrorState extends HomeLayoutStates
{
  final String error;
  LikePostErrorState(this.error);
}

class UnLikePostSucessState extends HomeLayoutStates {}

class UnLikePostLoadingState extends HomeLayoutStates {}

class UnLikePostErrorState extends HomeLayoutStates
{
  final String error;
  UnLikePostErrorState(this.error);
}

class GetLikedUsersSucessState extends HomeLayoutStates {}

class GetLikedUsersLoadingState extends HomeLayoutStates {}

class CommentsPostSucessState extends HomeLayoutStates {}

class CommentsPostLoadingState extends HomeLayoutStates {}

class CommentsPostErrorState extends HomeLayoutStates
{
  final String error;
  CommentsPostErrorState(this.error);
}



//cover and profile picking states
class ProfilePickedSucessState extends HomeLayoutStates {}

class ProfilePickedErrorState extends HomeLayoutStates {}

class CoverPickedSucessState extends HomeLayoutStates {}

class CoverPickedErrorState extends HomeLayoutStates {}


//uploading cover and profile images states
class UploadProfileImageSucess extends HomeLayoutStates {}

class UploadProfileImageError extends HomeLayoutStates {}

class UploadCoverImageSucess extends HomeLayoutStates {}

class UploadCoverImageError extends HomeLayoutStates {}

class UploadProfileImageLoading extends HomeLayoutStates {}

class UploadCoverImageLoading extends HomeLayoutStates {}

//updating user
class UpdateUserError extends HomeLayoutStates {}
class UpdateUserLoading extends HomeLayoutStates {}

//create new post states
class CreateNewPostSucessState extends HomeLayoutStates {}

class CreateNewPostErrorState extends HomeLayoutStates {}

class CreateNewPostLoadingState extends HomeLayoutStates {}

class PostImagePickedSucessState extends HomeLayoutStates {}

class PostImagePickedErrorState extends HomeLayoutStates {}

class PostImageRemovedState extends HomeLayoutStates {}

//chat
class SendMessageSucessState extends HomeLayoutStates {}

class SendMessageErrorState extends HomeLayoutStates {}

class GetMessageSucessState extends HomeLayoutStates {}

class GetMessageLoadingState extends HomeLayoutStates {}

class GetMessageErrorState extends HomeLayoutStates {}

class AppChangeBottomSheet extends HomeLayoutStates {}

//search

class SearchSucessState extends HomeLayoutStates {}

class SearchLoadingState extends HomeLayoutStates {}