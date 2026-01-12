import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the new file we just created
import 'screen/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course App',
      theme: ThemeData(
        useMaterial3: true,
        // Using Poppins globally so we don't have to set it everywhere
        textTheme: GoogleFonts.poppinsTextTheme(), 
      ),
      home: const OnboardingScreen(),
    );
  }
}