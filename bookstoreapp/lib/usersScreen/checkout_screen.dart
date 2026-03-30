import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controller/order_controller.dart';
import '../models/cart_model.dart';
import 'user_home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({super.key, required this.totalAmount, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final OrderController _orderController = OrderController();

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 60),
                ),
                const SizedBox(height: 20),
                Text(
                  "Order Confirmed!",
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your book is on the way.\nThank you for shopping!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E5CE6),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const UserHomeScreen()),
                      (route) => false,
                    );
                  },
                  child: Text("Back to Home", 
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator())
        );

        await _orderController.placeOrder(
          items: widget.cartItems.map((e) => CartItemModel.fromFirestore(e)).toList(),
          totalAmount: widget.totalAmount,
          userName: _nameController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
        );

        if (mounted) Navigator.pop(context); // Loader khatam

        _showSuccessDialog();

      } catch (e) {
        if (mounted) Navigator.pop(context); // Loader khatam
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        title: Text("Checkout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Shipping Details", 
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildTextField(_nameController, "Full Name", Icons.person),
              _buildTextField(_phoneController, "Phone Number", Icons.phone, inputType: TextInputType.phone),
              _buildTextField(_addressController, "Delivery Address", Icons.location_on, maxLines: 3),
              
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
                        Text("Rs. ${widget.totalAmount.toStringAsFixed(2)}", 
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF5E5CE6))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E5CE6),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: _placeOrder,
                      child: Text("Confirm Order", 
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF5E5CE6)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        ),
        validator: (value) => value!.isEmpty ? "This field is required" : null,
      ),
    );
  }
}
