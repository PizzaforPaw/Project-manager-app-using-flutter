import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB), // Light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP BAR (Hello User + Avatar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Alvart Ainstain",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // --- CHANGED SECTION START ---
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Optional: White border to make it pop against the background
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 28, // Size of the avatar
                        backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/300?img=12'), // Placeholder Image
                      ),
                    )
                    // --- CHANGED SECTION END ---
                  ],
                ),
                const SizedBox(height: 30),

                // 3. HORIZONTAL PROJECT LIST
                SizedBox(
                  height: 240,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none, // Allows shadow to show
                    children: [
                      _buildProjectCard(
                        title: "Testing Hard",
                        subtitle: "3 Tasks",
                        color: const Color(0xFF756EF3), // The purple color
                        percent: 0.85,
                      ),
                      _buildProjectCard(
                        title: "Management",
                        subtitle: "9 Tasks",
                        color: const Color(0xFFFF8484), // The pink/red color
                        percent: 0.40,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 4. TASKS HEADER
                Text(
                  "Tasks",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // 5. VERTICAL TASK LIST
                _buildTaskRow("Mobile App Design", "Mike and Anita", 0.75,
                    Colors.purple),
                _buildTaskRow("Landing Page", "Anita", 0.50, Colors.orange),
                _buildTaskRow(
                    "Dashboard Interaction", "Mike", 0.25, Colors.blue),
              ],
            ),
          ),
        ),
      ),

      // OPTIONAL: Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF756EF3),
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

  // WIDGET: The Colorful Project Card
  Widget _buildProjectCard(
      {required String title,
      required String subtitle,
      required Color color,
      required double percent}) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.access_time_filled, color: Colors.white),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: percent,
            progressColor: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.2),
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // WIDGET: The White Task Row
  Widget _buildTaskRow(String title, String team, double percent, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 25.0,
            lineWidth: 5.0,
            percent: percent,
            center: Text("${(percent * 100).toInt()}%",
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            progressColor: color,
            backgroundColor: color.withOpacity(0.1),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  team,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}