import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_dashboard_screen.dart';
import 'my_orders_screen.dart';
import '../Screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final User? currentUser = FirebaseAuth.instance.currentUser; 
  bool isLoading = false;
  int? userRole; // 0 for Admin, 1 for User

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    if (currentUser != null) {
      _emailController.text = currentUser!.email ?? "";
    }
    _loadFirestoreData();
  }

  Future<void> _loadFirestoreData() async {
    if (currentUser == null) return;

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = data['username'] ?? ""; 
        _fatherNameController.text = data['fatherName'] ?? "";
        _birthDateController.text = data['dob'] ?? "";
        userRole = data['role'] ?? 1;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (currentUser == null) return;

    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).set({
        'username': _nameController.text,
        'fatherName': _fatherNameController.text,
        'dob': _birthDateController.text,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Profile", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF5E5CE6),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 30),
            
            _buildProfileField(_emailController, "Email Address", Icons.email_outlined, isReadOnly: true),
            _buildProfileField(_nameController, "Full Name", Icons.person_outline),
            _buildProfileField(_fatherNameController, "Father's Name", Icons.family_restroom),
            _buildProfileField(_birthDateController, "Date of Birth", Icons.calendar_today),
            
            const SizedBox(height: 20),
            
            isLoading 
              ? const CircularProgressIndicator() 
              : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E5CE6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Save Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
            
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersScreen()));
                },
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF5E5CE6)),
                label: Text("My Orders", style: GoogleFonts.poppins(color: const Color(0xFF5E5CE6), fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF5E5CE6)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 15),
            
            if (userRole == 0) 
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboardScreen()));
                },
                icon: const Icon(Icons.admin_panel_settings, color: Colors.orange),
                label: Text("Admin Dashboard", style: GoogleFonts.poppins(color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 15),
            TextButton(
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
              child: Text("Logout", style: GoogleFonts.poppins(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(TextEditingController controller, String label, IconData icon, {bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF5E5CE6)),
          filled: true,
          fillColor: isReadOnly ? Colors.grey[50] : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        ),
      ),
    );
  }
}