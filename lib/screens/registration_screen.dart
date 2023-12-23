import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_message/data/socket_resources/socket_methods.dart';
import 'package:live_message/screens/login_screen.dart';
import 'package:live_message/utils/shared.dart';
import 'package:live_message/widgets/app_text_button.dart';
import 'package:live_message/widgets/app_textfield.dart';
import 'package:live_message/widgets/screen_title.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "/registration";

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _password;
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.onRegistrationSuccessListener(context);
    _socketMethods.onErrorOccuredListener(context);
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  gotoLoginPage() {
    Navigator.pushNamed(context, LoginScreen.routeName);
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
                const ScreenTitle(text: "Registration"),
                const Gap(24.0),
                CustomTextField(
                    controller: _name,
                    label: "Name",
                    onType: (input) {
                      if (input.isEmpty) {
                        showSnackBar(context, "Name can't be empty!");
                      }
                    },
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next),
                CustomTextField(
                    controller: _email,
                    label: "Email",
                    onType: (input) {
                      if (input.isEmpty) {
                        showSnackBar(context, "Email can't be empty!");
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next),
                CustomTextField(
                    controller: _password,
                    label: "Password",
                    onType: (input) {
                      if (input.isEmpty) {
                        showSnackBar(context, "Password can't be empty!");
                      }
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done),
                const Gap(16.0),
                CustomButton(
                    onTap: () {
                      if (_name.text.isNotEmpty &&
                          _email.text.isNotEmpty &&
                          _password.text.isNotEmpty) {
                        _socketMethods.registerUser(
                            name: _name.text,
                            email: _email.text,
                            password: _password.text);
                      } else {
                        showSnackBar(context, "Please fill out all the fields");
                      }
                    },
                    text: "Register")
              ],
            ),
            CustomButton(
                text: "Already a register user, Sign in",
                onTap: () {
                  gotoLoginPage();
                },
                enableBorder: false)
          ],
        ),
      ),
    );
  }
}
