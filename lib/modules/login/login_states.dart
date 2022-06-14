
abstract class ShopLoginStates { }

class LoginInitialStates extends ShopLoginStates { }

class LoginLoadingStates extends ShopLoginStates { }


class LoginSucessStates extends ShopLoginStates {
  final String uId;
  LoginSucessStates(this.uId);
}

class LoginErrorStates extends ShopLoginStates {
  final String error;
  LoginErrorStates(this.error);
}


class SuffixPressed extends ShopLoginStates { }