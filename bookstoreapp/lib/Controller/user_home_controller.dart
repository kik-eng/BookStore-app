import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class UserHomeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Saari books fetch aur filter/sort karne ke liye (Ab Firestore se)
  Stream<List<BookModel>> getBooks({String? query, String? sortBy}) {
    Query booksQuery = _db.collection("books");

    // Sorting logic (Note: Firestore requires indexes for these. Simple client-side sorting is also an option)
    if (sortBy == "Price: Low to High") {
      booksQuery = booksQuery.orderBy("price", descending: false);
    } else if (sortBy == "Popularity") {
      booksQuery = booksQuery.orderBy("rating", descending: true);
    }

    return booksQuery.snapshots().map((snapshot) {
      List<BookModel> books = snapshot.docs
          .map((doc) => BookModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Client-side filtering for Title, Author, or Genre
      if (query != null && query.isNotEmpty) {
        String lowerQuery = query.toLowerCase();
        books = books.where((book) {
          return book.title.toLowerCase().contains(lowerQuery) ||
              book.author.toLowerCase().contains(lowerQuery) ||
              book.genre.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      return books;
    });
  }

  // 2. Click karne par Single Book ki details fetch karne ke liye (Ab Firestore se)
  Future<BookModel?> getBookDetails(String bookId) async {
    var doc = await _db.collection("books").doc(bookId).get();
    if (doc.exists) {
      return BookModel.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }
}