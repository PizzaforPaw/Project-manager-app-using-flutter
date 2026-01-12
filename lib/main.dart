import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Import Firebase Core
import 'firebase_options.dart'; // 2. Import the generated options file

// Import your existing screen
import 'screen/onboarding_screen.dart';

// 3. Convert main() to an async function
void main() async {
  // 4. Ensure Flutter bindings are initialized before calling native code (Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // 5. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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