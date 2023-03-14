import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:toast/toast.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FacebookLogin facebookSignIn = FacebookLogin();

class AuthService {
  authCreateUser(
      {String emailInput, String passwordInput, BuildContext context}) async {
    UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: emailInput, password: passwordInput);
    print(result.user.uid);
  }

  authSignInUser(
      {String emailInput, String passwordInput, BuildContext context}) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: emailInput, password: passwordInput);
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var firebaseUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return firebaseUser;
    } catch (e) {
      Toast.show(e.toString(), context,
          backgroundColor: Colors.blue, textColor: Colors.white, duration: 10);
      return null;
    }
  }

  signOutGoogle(BuildContext context) async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      Toast.show(e.toString(), context,
          backgroundColor: Colors.blue, textColor: Colors.white, duration: 10);
    }
  }

  signWithFaceBook(BuildContext context) async {
    await facebookSignIn.logOut();
    final result = await facebookSignIn.logIn(["email"]);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
        final profile = jsonDecode(graphResponse.body);
        print("facebook token : $token");
        print(profile.toString());
        print(profile['email']);
        await setPrefStringValue(facebook_details, graphResponse.body);
        print("login Successfully");
        return profile;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelled by user");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
    }
  }

  signOutFacebook(BuildContext context) async {
    await facebookSignIn.logOut();
    print('Sign out.');
  }
}
