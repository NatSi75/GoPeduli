import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/repository/category_model.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all category from the 'category' collection
  Future<List<CategoryModel>> getAllCategory() async {
    try {
      final snapshot = await _db.collection("category").get();
      final result =
          snapshot.docs.map((e) => CategoryModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Create a new category document in the 'category' collection
  Future<String> createCategory(CategoryModel category) async {
    try {
      final result = await _db.collection("category").add(category.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Delete an existing category document from the 'category' collection
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _db.collection('category').doc(categoryId).delete();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }
}
