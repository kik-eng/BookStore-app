class BookModel {
  final String id, title, author, image, price, description, genre;
  final double rating;

  BookModel({
    required this.id, required this.title, required this.author,
    required this.image, required this.price, required this.description,
    required this.genre, required this.rating,
  });

  // Firestore Map ko BookModel Object mein badalne ke liye
  factory BookModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return BookModel(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] ?? '0',
      description: data['description'] ?? 'No description available.',
      genre: data['genre'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }
}