import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/auth/login_screen.dart';
import 'package:bookstoreapp/usersScreen/admin_orders_screen.dart';
import 'package:bookstoreapp/usersScreen/add_edit_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controller/admin_controller.dart';
import '../models/book_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  final AdminController _controller = AdminController();

  AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminOrdersScreen()),
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF5E5CE6)),
            tooltip: "Manage Orders",
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: "Logout",
          ),
        ],
      ),
      body: StreamBuilder<List<BookModel>>(
        stream: _controller.getAllBooksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Books in Store", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator()),
                      );
                      await _controller.seedInitialBooks();
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("15 Sample Books Added! ✨"), backgroundColor: Colors.green),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5E5CE6)),
                    icon: const Icon(Icons.auto_awesome, color: Colors.white),
                    label: Text("Seed 15 Sample Books", style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return _buildBookItem(context, book);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditBookScreen()),
          );
        },
        backgroundColor: const Color(0xFF5E5CE6),
        label: Text("Add Book", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, BookModel book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              book.image,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 70,
                color: Colors.grey[200],
                child: const Icon(Icons.book, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title, 
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  book.author, 
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("Rs. ${book.price}", style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF5E5CE6), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
              );
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
          ),
          IconButton(
            onPressed: () => _controller.deleteBook(book.id),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }
}
