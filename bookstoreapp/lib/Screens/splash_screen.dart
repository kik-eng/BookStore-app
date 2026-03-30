import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'on_boarding_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreens()),
      );
    });
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.4,
              width: size.width * 0.9,
              child: Image.asset("images/splashscrn.jpg", fit: BoxFit.contain),
            ),
            SizedBox(height: 1),
            Text(
              "BOOK STORE",
              style: GoogleFonts.poppins(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5E5CE6),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),

            
            Text(
              "Your next adventure is just a page away.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
