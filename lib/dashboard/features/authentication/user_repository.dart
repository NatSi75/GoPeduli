import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:gopeduli/dashboard/helper/firebase_auth_exceptions.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  // FirebaseAuth instance
  final _db = FirebaseFirestore.instance;

  // Function to save user data to Firestore.
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw GoPeduliAuthException(e.code).message;
    } catch (e) {
      throw 'An error occurred while saving user data: $e';
    }
  }

  // Function to fetch user details based on user ID.
  Future<UserModel> fetchAdminDetails() async {
    try {
      final docSnapshot = await _db
          .collection('users')
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();
      return UserModel.fromSnapshot(docSnapshot);
    } on FirebaseAuthException catch (e) {
      throw GoPeduliAuthException(e.code).message;
    } catch (e) {
      throw 'An error occurred while saving user data: $e';
    }
  }
}
