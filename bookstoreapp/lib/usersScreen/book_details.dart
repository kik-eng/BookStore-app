import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book_model.dart';
import '../Controller/cart_controller.dart';

class BookDetails extends StatelessWidget {
  final BookModel book;
  final CartController _cartController = CartController();

  BookDetails({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: book.id,
                child: Image.network(book.image, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E5CE6).withAlpha(26),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          book.genre,
                          style: GoogleFonts.poppins(color: const Color(0xFF5E5CE6), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "by ${book.author}",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(" ${book.rating} / 5.0", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Text(
                        "Rs. ${book.price}",
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF5E5CE6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book.description,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], height: 1.6),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E5CE6),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: () {
            _cartController.addToCart(book);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Added to Cart 🛒"), backgroundColor: Colors.green),
            );
          },
          child: Text(
            "Add to Cart",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}