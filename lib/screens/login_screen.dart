import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_message/data/socket_resources/socket_methods.dart';
import 'package:live_message/screens/home_screen.dart';
import 'package:live_message/screens/registration_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:live_message/widgets/app_text_button.dart';
import 'package:live_message/widgets/app_textfield.dart';
import 'package:live_message/widgets/screen_title.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _email;
  late TextEditingController _password;

  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.onLoginSuccessListener(context);
    _socketMethods.onErrorOccuredListener(context);
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  gotoRegistrationPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, RegistrationScreen.routeName);
  }

  gotoHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(16.0),
                const ScreenTitle(text: "Login"),
                const Gap(24.0),
                CustomTextField(
                    controller: _email,
                    label: "Email",
                    onType: (input) {
                      if (input.isEmpty) {
                        showSnackBar(context, "Email can't be empty!");
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress),
                CustomTextField(
                    controller: _password,
                    label: "Password",
                    onType: (input) {
                      if (input.isEmpty) {
                        showSnackBar(context, "Password can't be empty!");
                      }
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text),
                const Gap(16.0),
                CustomButton(
                    onTap: () {
                      // if(_email.text.isNotEmpty && _password.text.isNotEmpty){
                      //       _socketMethods.loginUser(_email.text, _password.text);
                      // }else{
                      //   showSnackBar(context, "Please fill out all the fields");
                      // }

                      Navigator.pushNamed(context, HomeScreen.routeName);

                    },
                    text: "Login")
              ],
            ),
            CustomButton(
                text: "Don't have an Account, Register here",
                onTap: () {
                  gotoRegistrationPage(context);
                },
                enableBorder: false)
          ],
        ),
      ),
    );
  }
}
