import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../models/cart_model.dart';
import 'cart_controller.dart';
import 'package:uuid/uuid.dart';

class OrderController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CartController _cartController = CartController();

  // Dynamic userId nikalne ke liye
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? "";

  // 1. Order Place Karna (Cart Items ko Orders mein move karna)
  Future<void> placeOrder({
    required List<CartItemModel> items,
    required double totalAmount,
    required String userName,
    required String address,
    required String phone,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception("User not logged in");
    }

    try {
      String orderId = const Uuid().v4();
      
      OrderModel newOrder = OrderModel(
        orderId: orderId,
        userId: userId,
        items: items.map((item) => item.toMap()).toList(),
        totalAmount: totalAmount,
        userName: userName,
        address: address,
        phone: phone,
        status: "Pending",
        orderedAt: DateTime.now(),
      );

      await _db.collection("orders").doc(orderId).set(newOrder.toMap());
      await _cartController.clearCart();
      
    } catch (e) {
      print("Error placing order: $e");
      rethrow;
    }
  }

  // 2. User ke saare orders fetch karna
  Stream<List<OrderModel>> getUserOrders() {
    return _db
        .collection("orders")
        .where("userId", isEqualTo: userId)
        .orderBy("orderedAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // 3. Admin ke liye order status update karna
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db.collection("orders").doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      print("Error updating order status: $e");
      rethrow;
    }
  }

  // 4. Admin ke liye saare orders
  Stream<List<OrderModel>> getAllOrders() {
    return _db
        .collection("orders")
        .orderBy("orderedAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}
