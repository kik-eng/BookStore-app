import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_model.dart';
import '../models/book_model.dart';

class CartController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Dynamic userId nikalne ke liye
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? "";

  // 1. Add to Cart
  Future<void> addToCart(BookModel book) async {
    try {
      var cartDoc = _db.collection("users").doc(userId).collection("cart").doc(book.id);
      
      var docSnapshot = await cartDoc.get();
      if (docSnapshot.exists) {
        int currentQuantity = docSnapshot.data()?['quantity'] ?? 1;
        await cartDoc.update({'quantity': currentQuantity + 1});
      } else {
        CartItemModel newItem = CartItemModel(
          bookId: book.id,
          title: book.title,
          image: book.image,
          price: book.price,
          quantity: 1,
        );
        await cartDoc.set(newItem.toMap());
      }
    } catch (e) {
      print("Error adding to cart: $e");
      rethrow;
    }
  }

  // 2. Cart Items Fetch Karna
  Stream<List<CartItemModel>> getCartItems() {
    return _db
        .collection("users")
        .doc(userId)
        .collection("cart")
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItemModel.fromFirestore(doc.data()))
            .toList());
  }

  // 3. Total Price Calculate Karna
  double calculateTotalPrice(List<CartItemModel> items) {
    double total = 0.0;
    for (var item in items) {
      double price = double.tryParse(item.price) ?? 0.0;
      total += price * item.quantity;
    }
    return total;
  }

  // 4. Quantity Update Karna
  Future<void> updateQuantity(String bookId, int newQuantity) async {
    if (newQuantity < 1) {
      await removeFromCart(bookId);
      return;
    }
    
    await _db
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(bookId)
        .update({'quantity': newQuantity});
  }

  // 5. Item Remove Karna
  Future<void> removeFromCart(String bookId) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(bookId)
        .delete();
  }

  // 6. Cart Khali Karna
  Future<void> clearCart() async {
    var snapshots = await _db.collection("users").doc(userId).collection("cart").get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}