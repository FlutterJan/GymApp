import 'package:flutter/src/widgets/framework.dart';
import 'package:ucze_sie_swiry/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(onclickedSignUp: toggle)
        : SignUpPage(onClickedSignIn: toggle);
  }
}
