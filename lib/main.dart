import 'package:flutter/material.dart';
import 'package:live_message/data/provider/room_data_provider.dart';
import 'package:live_message/screens/home_screen.dart';
import 'package:live_message/screens/login_screen.dart';
import 'package:live_message/screens/message_screen.dart';
import 'package:live_message/screens/profile_screen.dart';
import 'package:live_message/screens/registration_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoomDataProvider(),
      child: MaterialApp(
        title: 'Live Message',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegistrationScreen.routeName: (context) => const RegistrationScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          MessageScreen.routeName: (context) => const MessageScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
        },
        initialRoute: LoginScreen.routeName,
      ),
    );
  }
}
