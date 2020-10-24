import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chats/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    PickedFile image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    var authResult ;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
      authResult =   await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
      authResult =   await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance.ref().child('user_images').child(authResult.user.uid + '.jpg');
        final pathS = File(image.path);
        await ref.putFile(pathS).onComplete;

        final url = await ref.getDownloadURL();

       await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
         'username' : username,
         'email' : email,
         'image_url' : url,
       });
      }
    } on PlatformException catch (err) {
      String messages = 'An error occurred , please chick your credentials';
      if (err.message != null) {
        messages = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(messages),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading
      ),
    );
  }
}
