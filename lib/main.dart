import 'package:flutter/material.dart';
import 'package:flutter_chats/screens/auth_screen.dart';
import 'package:flutter_chats/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chats/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(builder: (ctx, userSnapshots) {
        if(userSnapshots.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if(userSnapshots.hasData) {
          return ChatScreen();
        }
        return AuthScreen();
      },stream: FirebaseAuth.instance.onAuthStateChanged,),
    );
  }
}
