import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controller/admin_controller.dart';
import '../models/book_model.dart';

class AddEditBookScreen extends StatefulWidget {
  final BookModel? book;
  const AddEditBookScreen({super.key, this.book});

  @override
  State<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminController _controller = AdminController();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _imageController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _ratingController;
  String? _selectedGenre;

  final List<String> _genres = [
    'Fiction',
    'Romance',
    'Science',
    'History',
    'Philosophy',
    'Mystery'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? "");
    _authorController = TextEditingController(text: widget.book?.author ?? "");
    _imageController = TextEditingController(text: widget.book?.image ?? "");
    _priceController = TextEditingController(text: widget.book?.price ?? "");
    _descriptionController = TextEditingController(text: widget.book?.description ?? "");
    _ratingController = TextEditingController(text: widget.book?.rating.toString() ?? "0.0");
    _selectedGenre = widget.book?.genre ?? _genres[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      BookModel book = BookModel(
        id: widget.book?.id ?? "", 
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        image: _imageController.text.trim(),
        price: _priceController.text.trim(),
        description: _descriptionController.text.trim(),
        genre: _selectedGenre ?? "Fiction",
        rating: double.tryParse(_ratingController.text) ?? 0.0,
      );

      try {
        if (widget.book == null) {
          await _controller.addBook(book);
        } else {
          await _controller.updateBook(book);
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.book == null ? "Add New Book" : "Edit Book",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Book Title"),
              _buildTextField(_titleController, "Enter book title"),
              const SizedBox(height: 15),
              _buildLabel("Author Name"),
              _buildTextField(_authorController, "Enter author name"),
              const SizedBox(height: 15),
              _buildLabel("Image URL"),
              _buildTextField(_imageController, "Enter book cover URL"),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Price"),
                        _buildTextField(_priceController, "Price", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Rating"),
                        _buildTextField(_ratingController, "Rating (0.0 - 5.0)", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildLabel("Category (Genre)"),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                items: _genres.map((String genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(genre, style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGenre = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              _buildLabel("Description"),
              _buildTextField(_descriptionController, "Enter description", maxLines: 4),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E5CE6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    widget.book == null ? "Save Book" : "Update Book",
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Field cannot be empty";
        }
        return null;
      },
    );
  }
}
