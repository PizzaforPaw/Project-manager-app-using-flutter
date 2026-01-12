import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. BACKGROUND BLOBS (Reverted to this)
          const Positioned(
            top: -100,
            left: -100,
            child: CircleAvatar(
              radius: 200,
              backgroundColor: Color(0xFF5A65E8), // Purple/Blue Blob
            ),
          ),
          const Positioned(
            top: 100,
            right: -100,
            child: CircleAvatar(
              radius: 180,
              backgroundColor: Color(0xFFFF6B6B), // Pink/Red Blob
            ),
          ),

          // 2. GLASS EFFECT
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), // High blur for smooth gradients
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // 3. MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "Learn\ndesign\n& code",
                    style: GoogleFonts.poppins(
                      fontSize: 60,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      color: Colors.black87, // Dark text for white background
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Don't skip design. Learn design and code by building real apps with Flutter and Swift.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),

                  // 4. START BUTTON
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: "Sign In",
                        transitionDuration: const Duration(milliseconds: 750),
                        pageBuilder: (context, anim1, anim2) {
                          return const Align(
                            alignment: Alignment.center,
                            child: SignInDialog(),
                          );
                        },
                        transitionBuilder: (context, anim1, anim2, child) {
                          return SlideTransition(
                            position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                                .animate(CurvedAnimation(
                                    parent: anim1, curve: Curves.easeOutCubic)),
                            child: child,
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.arrow_forward),
                          SizedBox(width: 10),
                          Text(
                            "Start the course",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// SIGN IN MODAL WITH CLOSE BUTTON
// ---------------------------------------------------------



// ---------------------------------------------------------
// SIGN IN MODAL WITH OVERLAPPING CLOSE BUTTON
// ---------------------------------------------------------

class SignInDialog extends StatefulWidget {
  const SignInDialog({super.key});

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  // 1. Controllers to capture text input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // 2. Loading state to show a spinner while logging in
  bool _isLoading = false;

  // 3. The Firebase Login Function
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // Success: Close dialog and navigate
      Navigator.of(context).pop(); 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );

    } on FirebaseAuthException catch (e) {
      // Error: Show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An error occurred"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // 1. THE MAIN CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 48),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sign in",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Access to your working progress and continue to work effectively by tracking this app.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 30),

                  // EMAIL INPUT (Pass controller here)
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Email",
                    icon: Icons.email_outlined,
                    iconColor: Colors.pinkAccent,
                  ),
                  const SizedBox(height: 16),

                  // PASSWORD INPUT (Pass controller here)
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    iconColor: Colors.pinkAccent,
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),

                  // SIGN IN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn, // Disable button if loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF77D8E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xFFF77D8E).withOpacity(0.5),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) // Show spinner
                        : const Text(
                            "Sign in",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // DIVIDER
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("OR",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.none)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SOCIAL ICONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialIcon(Icons.email, Colors.black),
                      _buildSocialIcon(Icons.apple, Colors.black),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEEBF1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.g_mobiledata,
                            size: 35, color: Color(0xFFF77D8E)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. THE CLOSE (X) BUTTON
            Positioned(
              bottom: -23,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 28, color: color),
    );
  }
}

// ---------------------------------------------------------
// CUSTOM TEXT FIELD (UPDATED TO ACCEPT CONTROLLER)
// ---------------------------------------------------------

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Color iconColor;
  final bool isPassword;
  final TextEditingController controller; // Added this

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.iconColor,
    required this.controller, // Added this
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        controller: controller, // Connect controller
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Colors.pinkAccent),
          ),
        ),
      ),
    );
  }
}

