import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String bookId;
  final String title;
  final String image;
  final String price;
  int quantity;

  CartItemModel({
    required this.bookId,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  // 1. Data ko Firestore mein save karne ke liye (Map mein convert karta hai)
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
      'addedAt': Timestamp.now(), // Sorting ke liye time bhi save kar rahe hain
    };
  }

  // 2. Firestore se data wapas lene ke liye (Map ko Object mein convert karta hai)
  factory CartItemModel.fromFirestore(Map<String, dynamic> map) {
    return CartItemModel(
      bookId: map['bookId'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '0',
      quantity: map['quantity'] ?? 1,
    );
  }
}