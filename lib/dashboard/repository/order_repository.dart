import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all order from the 'transactions' collection
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final snapshot = await _db.collection("transactions").get();
      final result =
          snapshot.docs.map((e) => OrderModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<List<OrderModel>> getAllOrdersPreviousThirtyDays() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime endOfPreviousMonth = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      final DateTime startOfPreviousMonth =
          endOfPreviousMonth.subtract(const Duration(days: 30));

      final querySnapshot = await _db
          .collection('transactions')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfPreviousMonth))
          .where('timestamp',
              isLessThan: Timestamp.fromDate(endOfPreviousMonth))
          .orderBy('timestamp', descending: false)
          .get();

      final orders = querySnapshot.docs
          .map((document) => OrderModel.fromSnapshot(document))
          .toList();
      return orders;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<List<OrderModel>> getAllOrdersThirtyDays() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime thirtyDaysAgoStartOfDay =
          DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 29));

      final querySnapshot = await _db
          .collection('transactions')
          .where('timestamp',
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(thirtyDaysAgoStartOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final orders = querySnapshot.docs
          .map((document) => OrderModel.fromSnapshot(document))
          .toList();

      return orders;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<List<OrderModel>> getAllOrdersSevenDays() async {
    try {
      // Hitung tanggal 7 hari yang lalu dari hari ini, pada pukul 00:00:00 (awal hari)
      final DateTime now = DateTime.now();
      final DateTime sevenDaysAgoStartOfDay =
          DateTime(now.year, now.month, now.day).subtract(const Duration(
              days: 6)); // Mulai dari 6 hari lalu (misal: Rabu lalu)

      // Query Firestore: Ambil dokumen dari koleksi 'transactions'
      // di mana 'timestamp' lebih besar atau sama dengan 7 hari yang lalu (mulai hari)
      final querySnapshot = await _db
          .collection(
              'transactions') // Pastikan nama koleksi ini benar di Firestore Anda
          .where('timestamp',
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(sevenDaysAgoStartOfDay))
          // Urutkan berdasarkan timestamp untuk konsistensi (opsional tapi disarankan)
          .orderBy('timestamp', descending: false)
          .get();

      // Konversi DocumentSnapshot menjadi OrderModel
      final orders = querySnapshot.docs
          .map((document) => OrderModel.fromSnapshot(document))
          .toList();

      return orders;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<List<OrderModel>> getAllOrdersOneDay() async {
    try {
      final DateTime now = DateTime.now();
      // Dapatkan awal hari ini (00:00:00)
      final DateTime startOfToday = DateTime(now.year, now.month, now.day);
      // Dapatkan awal hari besok (00:00:00)
      final DateTime startOfTomorrow =
          startOfToday.add(const Duration(days: 1));

      final querySnapshot = await _db
          .collection('transactions')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
          .where('timestamp',
              isLessThan: Timestamp.fromDate(
                  startOfTomorrow)) // Penting: isLessThan untuk akhir hari
          .orderBy('timestamp', descending: false)
          .get();

      final orders = querySnapshot.docs
          .map((document) => OrderModel.fromSnapshot(document))
          .toList();

      return orders;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<String> getUserNameById(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return doc.data()?['Name'] as String;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  Future<String> getUserEmailById(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return doc.data()?['Email'] as String;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Update Order Status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db
          .collection("transactions")
          .doc(orderId)
          .update({'status': newStatus});
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }
}
