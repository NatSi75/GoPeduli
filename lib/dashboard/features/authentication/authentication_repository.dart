import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/helper/firebase_auth_exceptions.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // FirebaseAuth instance
  final _auth = FirebaseAuth.instance;

  // Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  // Get IsAuthenticated User
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    if (kIsWeb) {
      _auth.setPersistence(Persistence.LOCAL);
    }
  }

  // Function to determine the relevang screen and redirect accordingly
  void screenRedirect() {
    final user = _auth.currentUser;
    if (user != null) {
      // User is signed in, redirect to home screen
      Get.offAllNamed(GoPeduliRoutes.dashboard);
    } else {
      // User is not signed in, redirect to login screen
      Get.offAllNamed(GoPeduliRoutes.login);
    }
  }

  // LOGIN
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw GoPeduliAuthException(e.code).message;
    } catch (e) {
      throw 'An unknown error occurred. Please try again later.';
    }
  }

  // REGISTER
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw GoPeduliAuthException(e.code).message;
    } catch (e) {
      throw 'An unknown error occurred. Please try again later.';
    }
  }

  // Logout User
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(GoPeduliRoutes.login);
    } on FirebaseAuthException catch (e) {
      throw GoPeduliAuthException(e.code).message;
    } catch (e) {
      throw 'An unknown error occurred. Please try again later.';
    }
  }
}
