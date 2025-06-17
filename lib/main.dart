import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_ily/screens/app_name.dart';
import 'package:note_ily/screens/homeScreen.dart';
import 'package:note_ily/screens/notes.dart';
import 'package:note_ily/screens/signup_screen.dart';
import 'package:note_ily/screens/to_do_list.dart';
import 'screens/onboarding1.dart';
import 'screens/onboarding2.dart';
import 'screens/loginScreen.dart';
import 'package:note_ily/screens/forget_pswd.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen(),
        '/onboarding1': (context) => const Onboarding1(),
        '/onboarding2': (context) => const Onboarding2(),
        '/login': (context) => const LoginScreen(),
        '/signup':(context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/notes':(context) => const NotesScreen(),
        '/to_do_list': (context) => const ToDoListScreen(),
        '/forget_pswd': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
