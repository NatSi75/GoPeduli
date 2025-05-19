import 'dart:io' as io;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:image_picker/image_picker.dart';

class ArticleRepository extends GetxController {
  static ArticleRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all articles from the 'articles' collection
  Future<List<ArticleModel>> getAllArticles() async {
    try {
      final snapshot = await _db.collection("articles").get();
      final result =
          snapshot.docs.map((e) => ArticleModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Creaete a new article document in the 'Articles' collection
  Future<String> createArticle(ArticleModel article) async {
    try {
      final result = await _db.collection("articles").add(article.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<String> uploadImageFile(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('path/to/image');
      final UploadTask uploadTask = ref.putData(await image.readAsBytes());
      await uploadTask.whenComplete(() => print('File uploaded'));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw FirebaseException(code: e.code, plugin: 'firebase_storage');
    } catch (e) {
      throw Exception('something');
    }
  }

  /// Upload raw Uint8List for web
  Future<String> uploadImageBytes(String path, Uint8List data) async {
    try {
      final ref = FirebaseStorage.instance
          .ref(path)
          .child('${DateTime.now().millisecondsSinceEpoch}.png');
      await ref.putData(data);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw FirebaseException(code: e.code, plugin: 'firebase_storage');
    } catch (e) {
      throw Exception('Upload failed.');
    }
  }
}
