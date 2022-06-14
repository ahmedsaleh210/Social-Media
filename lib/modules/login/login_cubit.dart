import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/login_states.dart';

class LoginCubit extends Cubit<ShopLoginStates> {
  LoginCubit() : super(LoginInitialStates());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isShown = false;

  void userLogin ({
    required String email,
    required String password,
  })
  {
    emit(LoginLoadingStates());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      emit(LoginSucessStates(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorStates(error.toString()));
      print(error.toString());
    });
  }

  void changePasswordSecure()
  {
    isShown = !isShown;
    emit(SuffixPressed());
  }

}