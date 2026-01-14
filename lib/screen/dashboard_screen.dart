import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

// IMPORTANT: Make sure this import matches your file name exactly!
// If your file is named "all_projects_screen.dart", change this line.
import 'all_projects_screen.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> tasks = [
    {"title": "Mobile App Design", "team": "Mike and Anita", "images": ['https://i.pravatar.cc/150?img=3', 'https://i.pravatar.cc/150?img=5'], "isChecked": false},
    {"title": "Landing Page", "team": "Anita", "images": ['https://i.pravatar.cc/150?img=5'], "isChecked": false},
    {"title": "Dashboard Interaction", "team": "Mike", "images": ['https://i.pravatar.cc/150?img=3'], "isChecked": false},
    {"title": "User Testing", "team": "Sarah", "images": ['https://i.pravatar.cc/150?img=9'], "isChecked": false},
  ];

  final List<Map<String, dynamic>> projects = [
    {"title": "Testing Hard", "subtitle": "3 Tasks", "color": const Color(0xFF756EF3), "percent": 0.85},
    {"title": "Management", "subtitle": "9 Tasks", "color": const Color(0xFFFF8484), "percent": 0.40},
    {"title": "Web Dev", "subtitle": "12 Tasks", "color": const Color(0xFF4AC1A0), "percent": 0.20},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildSectionTitle(context, title: "Projects", actionText: "See all"),
            const SizedBox(height: 10),
            _buildHorizontalProjectList(),
            const SizedBox(height: 30),
            _buildSectionTitle(context, title: "Tasks", isActionBtn: true),
            const SizedBox(height: 20),
            ...tasks.asMap().entries.map((entry) => _buildTaskCard(entry.value, entry.key)),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF5B67CA),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home, color: Color(0xFF5B67CA)), onPressed: () {}),
              IconButton(icon: const Icon(Icons.list_alt, color: Colors.grey), onPressed: () {}),
              const SizedBox(width: 40),
              IconButton(icon: const Icon(Icons.message_outlined, color: Colors.grey), onPressed: () {}),
              IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.grey), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER METHODS ---

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello,", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
            Text("Alvart Ainstain", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: const CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12')),
        )
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, {required String title, String? actionText, bool isActionBtn = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        if (isActionBtn)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFEBEAF8), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.add, size: 16, color: Color(0xFF756EF3)),
                const SizedBox(width: 5),
                Text("Add task", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF756EF3))),
              ],
            ),
          )
        else
          TextButton(
            onPressed: () {
              if (title == "Projects") {
                // Navigates to the external file class
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AllProjectsScreen()));
              }
            },
            child: Text(actionText ?? "", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
          ),
      ],
    );
  }

  Widget _buildHorizontalProjectList() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: project['color'], borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: project['color'].withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.search, color: Colors.white)),
                const Spacer(),
                Text(project['title'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(project['subtitle'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 20),
                LinearPercentIndicator(lineHeight: 6, percent: project['percent'], progressColor: Colors.white, backgroundColor: Colors.white.withOpacity(0.2), barRadius: const Radius.circular(10), padding: EdgeInsets.zero),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    bool isChecked = task['isChecked'];
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => tasks[index]['isChecked'] = !isChecked),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 28, width: 28,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isChecked ? Colors.green : Colors.transparent, border: Border.all(color: Colors.green, width: 2)),
              child: isChecked ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: isChecked ? TextDecoration.lineThrough : null, color: isChecked ? Colors.grey : Colors.black)),
                const SizedBox(height: 5),
                Text(task['team'], style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          if ((task['images'] as List).isNotEmpty)
             SizedBox(width: 50, height: 32, child: Stack(children: [Positioned(left: 0, child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(task['images'][0]))), if(task['images'].length > 1) Positioned(left: 20, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(task['images'][1]))))])),
        ],
      ),
    );
  }
}