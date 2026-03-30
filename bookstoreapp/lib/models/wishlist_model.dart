class WishlistItemModel {
  final String bookId;
  final String title;
  final String image;
  final String price;

  WishlistItemModel({
    required this.bookId,
    required this.title,
    required this.image,
    required this.price,
  });

  // Firebase se data lene ke liye
  factory WishlistItemModel.fromMap(Map<String, dynamic> map) {
    return WishlistItemModel(
      bookId: map['bookId'] ?? '',
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '',
    );
  }

  // Firebase mein save karne ke liye
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'title': title,
      'image': image,
      'price': price,
    };
  }
}