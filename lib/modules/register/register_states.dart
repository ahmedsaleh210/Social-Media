abstract class ShopRegisterStates { }

class RegisterInitialStates extends ShopRegisterStates { }

class RegisterLoadingStates extends ShopRegisterStates { }


class RegisterSucessStates extends ShopRegisterStates {
}

class RegisterErrorStates extends ShopRegisterStates {
  final String error;
  RegisterErrorStates(this.error);
}

class CreateUserSucessStates extends ShopRegisterStates {
}

class CreateUserErrorStates extends ShopRegisterStates {
  final String error;
  CreateUserErrorStates(this.error);
}

class SuffixPressed extends ShopRegisterStates { }