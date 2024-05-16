import 'package:flutter/cupertino.dart';

class LoginFormData extends ChangeNotifier{
  String email ="";
  String password ="";

  bool isButtonEnabled(){
    return email.isNotEmpty && password.isNotEmpty;
  }
}


class RegisterFormData extends ChangeNotifier{
  String name ="";
  String email ="";
  String password ="";
  String confirmPassword ="";

  bool isButtonEnabled(){
    return name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty;
  }
}
