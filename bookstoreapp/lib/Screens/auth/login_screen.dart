import 'package:bookstoreapp/Controller/auth_controller.dart';
import 'package:bookstoreapp/Screens/auth/register_screen.dart';
import 'package:bookstoreapp/Screens/auth/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              const SizedBox(height: 80),
              const Icon(Icons.auto_stories_rounded, size: 100, color: Color(0xFF5E5CE6)),
              const SizedBox(height: 10),
              Text(
                "Welcome Back",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5E5CE6),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(emailController, "Email Address", Icons.email),
              const SizedBox(height: 20),
              _buildPasswordField(),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.poppins(color: const Color(0xFF5E5CE6), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
                      _authController.signIn(
                        context: context,
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
                    "Login",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              const Text("OR", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () => _authController.signInWithGoogle(context),
                  icon: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png", height: 24),
                  label: Text("Sign in with Google", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    child: const Text(
                      "Register Now",
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