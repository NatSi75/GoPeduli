import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "Guest";
  String _userEmail = "";
  String _gender = "male";
  String _profilePicture = "";
  String _role = "Patient";
  bool _isLoading = false;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get gender => _gender;
  String get profilePicture => _profilePicture;
  String get role => _role;
  bool get isLoading => _isLoading;

  UserProvider() {
    // Removed authStateChanges listener to avoid overwriting user data after login
  }

  void setUserData({
    required String userName,
    required String userEmail,
    required String gender,
    required String role,
    required String profilePicture,
  }) {
    _userName = userName;
    _userEmail = userEmail;
    _gender = gender;
    _role = role;
    _profilePicture = profilePicture;
    debugPrint(
        'UserProvider updated: userName=$_userName, userEmail=$_userEmail, gender=$_gender, role=$_role, profilePicture=$_profilePicture');
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("No user is logged in.");
        _isLoading = false;
        notifyListeners();
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setUserData(
          userName: data['Name'] ?? 'Guest',
          userEmail: data['Email'] ?? '',
          gender: data['Gender'] ?? 'male',
          role: data['Role'] ?? 'Patient',
          profilePicture: data['ProfilePicture'] ?? '',
        );
      } else {
        debugPrint("User document does not exist.");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}
