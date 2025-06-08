import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/repository/author_model.dart';

class AuthorRepository extends GetxController {
  static AuthorRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all authors from the 'authors' collection
  Future<List<AuthorModel>> getAllAuthors() async {
    try {
      final snapshot = await _db.collection("authors").get();
      final result =
          snapshot.docs.map((e) => AuthorModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Create a new author document in the 'authors' collection
  Future<String> createAuthor(AuthorModel author) async {
    try {
      final result = await _db.collection("authors").add(author.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Delete an existing author document from the 'authors' collection
  Future<void> deleteAuthor(String authorId) async {
    try {
      await _db.collection('authors').doc(authorId).delete();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Update Author
  Future<void> updateAuthor(AuthorModel author) async {
    try {
      await _db.collection('authors').doc(author.id).update(author.toJson());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }
}
