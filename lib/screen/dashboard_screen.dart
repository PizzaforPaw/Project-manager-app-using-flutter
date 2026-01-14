import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ===========================================================================
  // 1. DATA SOURCE: TASKS
  // ===========================================================================
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "Mobile App Design",
      "team": "Mike and Anita",
      "images": ['https://i.pravatar.cc/150?img=3', 'https://i.pravatar.cc/150?img=5'],
      "isChecked": false,
    },
    {
      "title": "Landing Page",
      "team": "Anita",
      "images": ['https://i.pravatar.cc/150?img=5'],
      "isChecked": false,
    },
    {
      "title": "Dashboard Interaction",
      "team": "Mike",
      "images": ['https://i.pravatar.cc/150?img=3'],
      "isChecked": false,
    },
     {
      "title": "User Testing",
      "team": "Sarah",
      "images": ['https://i.pravatar.cc/150?img=9'],
      "isChecked": false,
    },
    {
      "title": "API Integration",
      "team": "Dev Team",
      "images": ['https://i.pravatar.cc/150?img=11', 'https://i.pravatar.cc/150?img=12'],
      "isChecked": false,
    },
  ];

  // ===========================================================================
  // 2. DATA SOURCE: PROJECTS
  // ===========================================================================
  final List<Map<String, dynamic>> projects = [
    {
      "title": "Testing Hard",
      "subtitle": "3 Tasks",
      "color": const Color(0xFF756EF3), // Purple
      "percent": 0.85,
    },
    {
      "title": "Management",
      "subtitle": "9 Tasks",
      "color": const Color(0xFFFF8484), // Pink
      "percent": 0.40,
    },
     {
      "title": "Web Dev",
      "subtitle": "12 Tasks",
      "color": const Color(0xFF4AC1A0), // Green
      "percent": 0.20,
    },
  ];

  // ===========================================================================
  // MAIN BUILD METHOD
  // ===========================================================================
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: SafeArea(
        // CHANGE: We use one single ListView for the WHOLE screen.
        // This removes the "fixed header" logic. Everything scrolls together.
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // 1. Header Section
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // 2. Projects Section
            _buildSectionTitle(title: "Projects", actionText: "See all"),
            const SizedBox(height: 10),
            _buildHorizontalProjectList(), 
            
            const SizedBox(height: 30),

            // 3. Tasks Section
            _buildSectionTitle(title: "Tasks", isActionBtn: true),
            const SizedBox(height: 20),

            // 4. Task List Items
            // We use the spread operator (...) to put the list items directly here
            ...tasks.asMap().entries.map((entry) {
              return _buildTaskCard(entry.value, entry.key);
            }),
            
            // Extra padding at the bottom so the last item isn't hidden
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF756EF3),
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 30), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }

  // ===========================================================================
  // UI HELPER METHODS
  // ===========================================================================

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

  Widget _buildSectionTitle({required String title, String? actionText, bool isActionBtn = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
            onPressed: () {}, 
            child: Text(actionText ?? "", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey))
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
          return _buildProjectCardItem(
            title: project['title'],
            subtitle: project['subtitle'],
            color: project['color'],
            percent: project['percent'],
          );
        },
      ),
    );
  }

  Widget _buildProjectCardItem({required String title, required String subtitle, required Color color, required double percent}) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.search, color: Colors.white),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          LinearPercentIndicator(lineHeight: 6, percent: percent, progressColor: Colors.white, backgroundColor: Colors.white.withOpacity(0.2), barRadius: const Radius.circular(10), padding: EdgeInsets.zero),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    bool isChecked = task['isChecked'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                tasks[index]['isChecked'] = !tasks[index]['isChecked'];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? Colors.green : Colors.transparent,
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: isChecked ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                    color: isChecked ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(task['team'], style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          _buildAvatarStack(task['images']),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(List<String> images) {
    if (images.isEmpty) return const SizedBox();
    if (images.length == 1) {
      return CircleAvatar(radius: 16, backgroundImage: NetworkImage(images[0]));
    }
    return SizedBox(
      width: 50,
      height: 32,
      child: Stack(
        children: [
          Positioned(left: 0, child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(images[0]))),
          Positioned(left: 20, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(images[1])))),
        ],
      ),
    );
  }
}