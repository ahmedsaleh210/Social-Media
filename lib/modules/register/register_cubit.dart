import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/register_states.dart';

class RegisterCubit extends Cubit<ShopRegisterStates> {
  RegisterCubit() : super(RegisterInitialStates());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isShownPass = false;
  bool isShownConfirm = false;

  void userRegister ({
    required String email,
    required String password,
    required String name,
    required String phone,
  })
  {
    emit(RegisterLoadingStates());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password
    ).then((value) {
      createUser(
          email: email,
          uId: value.user!.uid.toString(),
          name: name,
          phone: phone
      );
    }).catchError((error) {
      emit(RegisterErrorStates(error.toString()));
      print(error.toString());
    });
  }

  void createUser({
    required String email,
    required String uId,
    required String name,
    required String phone,
})
  {
    UserModel model = UserModel(
      email: email,
      uId: uId,
      name: name,
      phone: phone,
      isEmailVerified: false, 
      bio: 'Write your bio...',
      image: 'https://image.freepik.com/free-photo/overemotive-black-man-dances-with-raised-fists-wears-headphones-ears_273609-37419.jpg',
      cover: 'https://image.freepik.com/free-photo/horizontal-shot-smiling-beautiful-woman-red-shirt-sits-front-opened-laptop-computer_273609-24653.jpg'
    );
    FirebaseFirestore.instance.
    collection('users')
        .doc(uId)
        .set(model.toJson())
        .then((value)
    {
        emit(CreateUserSucessStates());
    }).catchError(
            (error){
              emit(CreateUserErrorStates(error.toString()));
            });
  }

  void changePasswordSecure()
  {
    isShownPass = !isShownPass;
    emit(SuffixPressed());
  }

  void changeConfirmPassSecure()
  {
    isShownConfirm = !isShownConfirm;
    emit(SuffixPressed());
  }

}