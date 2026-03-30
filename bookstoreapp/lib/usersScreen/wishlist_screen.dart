import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controller/wishlist_controller.dart';
import '../models/wishlist_model.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistController _wishlistController = WishlistController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        title: Text(
          "My Wishlist",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<WishlistItemModel>>(
        stream: _wishlistController.getWishlistItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return _buildEmptyWishlist();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildWishlistItem(items[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildWishlistItem(WishlistItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.image,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Rs. ${item.price}",
                  style: GoogleFonts.poppins(color: const Color(0xFF5E5CE6), fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
            onPressed: () => _wishlistController.removeFromWishlist(item.bookId),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text(
            "Your wishlist is empty",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}