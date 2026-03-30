import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wishlist_model.dart';

class WishlistController {
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");
  
  // Dynamic userId using Auth
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? "";

  // Wishlist mein add karne ka function
  Future<void> addToWishlist(WishlistItemModel item) async {
    await _userRef.doc(userId).collection("wishlist").doc(item.bookId).set(item.toMap());
  }

  // Wishlist se remove karne ka function
  Future<void> removeFromWishlist(String bookId) async {
    await _userRef.doc(userId).collection("wishlist").doc(bookId).delete();
  }

  // Wishlist ka data stream (Real-time update ke liye)
  Stream<List<WishlistItemModel>> getWishlistItems() {
    return _userRef.doc(userId).collection("wishlist").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Updated to remove unnecessary cast and use Map strongly
        final data = doc.data() as Map<String, dynamic>; 
        return WishlistItemModel.fromMap(data);
      }).toList();
    });
  }
}