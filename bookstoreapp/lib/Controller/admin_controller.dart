import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../data/book_data.dart';

class AdminController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Add Book (Nayi Book Firestore mein save karne ke liye)
  Future<void> addBook(BookModel book) async {
    try {
      await _db.collection("books").add({
        'title': book.title,
        'author': book.author,
        'image': book.image,
        'price': book.price,
        'description': book.description,
        'genre': book.genre,
        'rating': book.rating,
      });
    } catch (e) {
      print("Error adding book: $e");
      rethrow;
    }
  }

  // 2. Update Book (Existing Book ko edit karne ke liye)
  Future<void> updateBook(BookModel book) async {
    try {
      await _db.collection("books").doc(book.id).update({
        'title': book.title,
        'author': book.author,
        'image': book.image,
        'price': book.price,
        'description': book.description,
        'genre': book.genre,
        'rating': book.rating,
      });
    } catch (e) {
      print("Error updating book: $e");
      rethrow;
    }
  }

  // 3. Delete Book (Book ko Firestore se delete karne ke liye)
  Future<void> deleteBook(String bookId) async {
    try {
      await _db.collection("books").doc(bookId).delete();
    } catch (e) {
      print("Error deleting book: $e");
      rethrow;
    }
  }

  // 4. Get all books for Admin Dashboard (Real-time Stream)
  Stream<List<BookModel>> getAllBooksStream() {
    return _db.collection("books").snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => BookModel.fromFirestore(doc.data(), doc.id)).toList());
  }

  // 5. Seed Initial Books (Hardcoded data ko Firestore mein transfer karne ke liye)
  Future<void> seedInitialBooks() async {
    for (var book in BookData.hardcodedBooks) {
      await addBook(book);
    }
  }
}
