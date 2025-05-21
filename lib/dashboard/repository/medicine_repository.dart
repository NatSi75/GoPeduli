import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';

class MedicineRepository extends GetxController {
  static MedicineRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all medicine from the 'medicines' collection
  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      final snapshot = await _db.collection("medicines").get();
      final result =
          snapshot.docs.map((e) => MedicineModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Creaete a new medicine document in the 'medicines' collection
  Future<String> createMedicine(MedicineModel medicine) async {
    try {
      final result = await _db.collection("medicines").add(medicine.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Delete an existing medicine document from the 'articles' collection
  Future<void> deleteMedicine(String medicineId) async {
    try {
      await _db.collection('medicines').doc(medicineId).delete();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Update Medicine
  Future<void> updateMedicine(MedicineModel medicine) async {
    try {
      await _db
          .collection('medicines')
          .doc(medicine.id)
          .update(medicine.toJson());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }
}
