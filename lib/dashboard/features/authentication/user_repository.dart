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

  /// Get total number of users
  Future<int> getTotalUsers() async {
    try {
      final snapshot = await _db
          .collection("users")
          .where('Role', isEqualTo: 'member')
          .get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<int> getNewUsersPreviousMonthly() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime endOfPreviousMonth = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      final DateTime startOfPreviousMonth = endOfPreviousMonth
          .subtract(const Duration(days: 30)); // Approximate 30 days prior

      final querySnapshot = await _db
          .collection("users")
          .where(
            'Role',
            isEqualTo: 'member',
          )
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfPreviousMonth))
          .where('createdAt',
              isLessThan: Timestamp.fromDate(endOfPreviousMonth))
          .get();

      return querySnapshot.docs.length;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<int> getNewUsersMonthly() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime thirtyDaysAgo = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));

      final querySnapshot = await _db
          .collection("users")
          .where(
            'Role',
            isEqualTo: 'member',
          )
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                  thirtyDaysAgo)) // Assuming a 'createdAt' field
          .get();

      return querySnapshot.docs.length;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get all users from the 'users' collection
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _db
          .collection("users")
          .where(
            'Role',
            isEqualTo: 'member',
          )
          .get();
      final result =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get all doctors from the 'users' collection
  Future<List<UserModel>> getAllDoctors() async {
    try {
      final snapshot = await _db
          .collection("users")
          .where(
            'Role',
            isEqualTo: 'doctor',
          )
          .get();
      final result =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get all couriers from the 'users' collection
  Future<List<UserModel>> getAllCouriers() async {
    try {
      final snapshot = await _db
          .collection("users")
          .where(
            'Role',
            isEqualTo: 'courier',
          )
          .get();
      final result =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

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

  // Delete an existing user document from the 'users' collection
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
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
