import 'package:bookstoreapp/Controller/auth_controller.dart';
import 'package:bookstoreapp/Screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AuthController _authController = AuthController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.menu_book_rounded, size: 100, color: Color(0xFF5E5CE6)),
              const SizedBox(height: 10),
              Text(
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5E5CE6),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(nameController, "Full Name", Icons.person),
              const SizedBox(height: 20),
              _buildTextField(emailController, "Email Address", Icons.email),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passController.text.isNotEmpty) {
                      _authController.signUp(
                        context: context,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passController.text.trim(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E5CE6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    "Register Now",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5E5CE6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF5E5CE6)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passController,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: GoogleFonts.poppins(fontSize: 14),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF5E5CE6)),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () => setState(() => isObscure = !isObscure),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
    );
  }
}
