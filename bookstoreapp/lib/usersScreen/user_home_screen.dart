import 'package:bookstoreapp/usersScreen/book_details.dart';
import 'package:bookstoreapp/usersScreen/wishlist_screen.dart';
import 'package:bookstoreapp/usersScreen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/book_model.dart';
import '../models/wishlist_model.dart';
import '../Controller/wishlist_controller.dart';
import '../Controller/user_home_controller.dart';
import 'cart_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeBody(),
    const WishlistScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5E5CE6),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String searchQuery = "";
  String sortBy = "Price: Low to High";
  final WishlistController _wishlistController = WishlistController();
  final UserHomeController _homeController = UserHomeController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Find Your Next Read",
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Color(0xFF5E5CE6),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search title, author, genre...",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF5E5CE6)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Sorting Options
              Row(
                children: [
                  Text("Sort by: ", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 10),
                  _buildSortChip("Price: Low to High"),
                  const SizedBox(width: 10),
                  _buildSortChip("Popularity"),
                ],
              ),
              const SizedBox(height: 20),

              _buildBanner(),
              const SizedBox(height: 25),

              Text("Explore Books", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // Books Grid using UserHomeController
              StreamBuilder<List<BookModel>>(
                stream: _homeController.getBooks(query: searchQuery, sortBy: sortBy),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  final books = snapshot.data ?? [];
                  if (books.isEmpty) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No Books Found"),
                    ));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return _buildBookCard(context, books[index]);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label) {
    bool isSelected = sortBy == label;
    return GestureDetector(
      onTap: () => setState(() => sortBy = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5E5CE6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF5E5CE6), width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xFF5E5CE6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, BookModel book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetails(book: book)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      book.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.book)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        _wishlistController.addToWishlist(WishlistItemModel(
                          bookId: book.id,
                          title: book.title,
                          image: book.image,
                          price: book.price,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to Wishlist ❤️"),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite_border, color: Colors.red, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, 
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(book.author, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rs. ${book.price}", 
                          style: GoogleFonts.poppins(color: const Color(0xFF5E5CE6), fontWeight: FontWeight.bold, fontSize: 12)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(" ${book.rating}", style: GoogleFonts.poppins(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF5E5CE6), Color(0xFF9291F3)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("New Arrivals", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text("Get 20% discount on your first purchase!", 
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}