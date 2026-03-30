import 'dart:async';
import 'package:bookstoreapp/Screens/auth/login_screen.dart';
import 'package:bookstoreapp/usersScreen/user_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 1. Sign Up Logic with Role-Based Access
  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      EasyLoading.show(status: 'Registering...');
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Role Logic: admin@gmail.com gets role 0, others get role 1
      int role = (email.toLowerCase() == "admin@gmail.com") ? 0 : 1;

      await _db.collection("users").doc(userCredential.user!.uid).set({
        "username": name,
        "email": email,
        "role": role, // 0: Admin, 1: User
        "createdAt": Timestamp.now(),
      });

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Registered Successfully!');
      
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      });

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Registration Failed")));
    }
  }

  // 2. Sign In Logic
  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      EasyLoading.show(status: 'Logging in...');
      
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      EasyLoading.dismiss();
      EasyLoading.showToast('Logged In Successfully');

      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserHomeScreen()));
      });

    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Login Failed")));
    }
  }

  // 3. Reset Password Logic
  Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      EasyLoading.show(status: 'Sending Reset Email...');
      await _auth.sendPasswordResetEmail(email: email);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Reset Link Sent to Email');
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Failed to send reset link")));
    }
  }

  // 4. Google Sign In Logic
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      EasyLoading.show(status: 'Google Sign-In...');
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        EasyLoading.dismiss();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Firestore update if new user
        DocumentSnapshot userDoc = await _db.collection("users").doc(user.uid).get();
        if (!userDoc.exists) {
          int role = (user.email?.toLowerCase() == "admin@gmail.com") ? 0 : 1;
          await _db.collection("users").doc(user.uid).set({
            "username": user.displayName ?? "User",
            "email": user.email,
            "role": role,
            "createdAt": Timestamp.now(),
          });
        }
      }

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Logged In with Google');
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserHomeScreen()));

    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign-In Error: $e")));
    }
  }
}
