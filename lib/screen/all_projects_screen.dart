import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllProjectsScreen extends StatefulWidget {
  const AllProjectsScreen({super.key});

  @override
  State<AllProjectsScreen> createState() => _AllProjectsScreenState();
}

class _AllProjectsScreenState extends State<AllProjectsScreen> {
  // ===========================================================================
  // 1. DATA SOURCES
  // ===========================================================================
  
  // List for "In Work" Column
  List<Map<String, dynamic>> inWorkProjects = [
    {
      "id": "1",
      "tag": "New Project",
      "tagColor": Colors.amber,
      "title": "Mobile App Design",
      "description": "Redesigning the main dashboard",
      "progressCurrent": 4,
      "progressTotal": 10,
      "priority": "High",
      "avatars": ['https://i.pravatar.cc/150?img=11', 'https://i.pravatar.cc/150?img=3'],
    },
    {
      "id": "2",
      "tag": "Dev",
      "tagColor": Colors.blueAccent,
      "title": "API Integration",
      "description": "Connecting to the backend",
      "progressCurrent": 2,
      "progressTotal": 10,
      "priority": "Medium",
      "avatars": ['https://i.pravatar.cc/150?img=3'],
    },
    {
      "id": "4",
      "tag": "Testing",
      "tagColor": Colors.redAccent,
      "title": "Unit Tests",
      "description": "Writing tests for auth module",
      "progressCurrent": 0,
      "progressTotal": 5,
      "priority": "High",
      "avatars": ['https://i.pravatar.cc/150?img=8'],
    },
  ];

  // List for "Completed" Column
  List<Map<String, dynamic>> completedProjects = [
    {
      "id": "3",
      "tag": "Design",
      "tagColor": Colors.purple,
      "title": "User Persona",
      "description": "Creating user profiles",
      "progressCurrent": 10,
      "progressTotal": 10,
      "priority": "Low",
      "avatars": ['https://i.pravatar.cc/150?img=5', 'https://i.pravatar.cc/150?img=9'],
    },
  ];

  // ===========================================================================
  // 2. DRAG AND DROP LOGIC
  // ===========================================================================
  
  void _onDrop(Map<String, dynamic> task, String targetStatus) {
    setState(() {
      // 1. Identify where the task currently is and remove it
      // We check both lists because we don't know where it came from initially
      bool wasInWork = inWorkProjects.any((t) => t['id'] == task['id']);
      bool wasCompleted = completedProjects.any((t) => t['id'] == task['id']);

      if (wasInWork) inWorkProjects.removeWhere((t) => t['id'] == task['id']);
      if (wasCompleted) completedProjects.removeWhere((t) => t['id'] == task['id']);

      // 2. Add it to the correct TARGET list
      if (targetStatus == "IN WORK") {
        inWorkProjects.insert(0, task);
      } else if (targetStatus == "COMPLETED") {
        completedProjects.insert(0, task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Kanban Board", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        // HORIZONTAL SCROLLING AREA
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildKanbanColumn(title: "IN WORK", tasks: inWorkProjects, status: "IN WORK"),
            const SizedBox(width: 16),
            _buildKanbanColumn(title: "COMPLETED", tasks: completedProjects, status: "COMPLETED"),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 3. UI BUILDERS
  // ===========================================================================

  Widget _buildKanbanColumn({required String title, required List<Map<String, dynamic>> tasks, required String status}) {
    // UPDATED: Made width smaller (0.65) so you can see the next column for easy dropping
    double columnWidth = MediaQuery.of(context).size.width * 0.65; 

    return DragTarget<Map<String, dynamic>>(
      onWillAccept: (data) => true, // Accept any map data
      onAccept: (data) {
        _onDrop(data, status);
      },
      builder: (context, candidateData, rejectedData) {
        // Visual feedback if a card is hovering over this column
        bool isHovering = candidateData.isNotEmpty;

        return Container(
          width: columnWidth,
          decoration: BoxDecoration(
            color: isHovering ? Colors.blue.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isHovering 
                ? Border.all(color: Colors.blue, width: 2) 
                : Border.all(color: Colors.transparent),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                      child: Text("${tasks.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              
              // TASK LIST
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildDraggableCard(tasks[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableCard(Map<String, dynamic> task) {
    // LongPressDraggable is better for lists so it doesn't conflict with scrolling
    return LongPressDraggable<Map<String, dynamic>>(
      data: task,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      
      // What you see under your finger
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          // Make the dragging card slightly smaller than the column width
          width: MediaQuery.of(context).size.width * 0.6, 
          child: Opacity(
            opacity: 0.9,
            child: _buildCardContent(task, isDragging: true),
          ),
        ),
      ),
      
      // What stays behind (Ghost)
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCardContent(task),
      ),
      
      // Normal Card
      child: _buildCardContent(task),
    );
  }

  Widget _buildCardContent(Map<String, dynamic> task, {bool isDragging = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDragging 
          ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]
          : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task['tagColor'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task['tag'], 
              style: TextStyle(color: task['tagColor'], fontSize: 10, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 10),
          
          // Title
          Text(task['title'], style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          
          // Description
          Text(task['description'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 12),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: task['progressCurrent'] / task['progressTotal'],
              minHeight: 4,
              backgroundColor: Colors.grey[100],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4AC1A0)),
            ),
          ),
          const SizedBox(height: 12),
          
          // Footer
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 24,
                child: Stack(
                  children: [
                    if ((task['avatars'] as List).isNotEmpty)
                       Positioned(left: 0, child: CircleAvatar(radius: 10, backgroundImage: NetworkImage(task['avatars'][0]))),
                    if ((task['avatars'] as List).length > 1)
                       Positioned(left: 15, child: CircleAvatar(radius: 10, backgroundImage: NetworkImage(task['avatars'][1]))),
                  ],
                ),
              ),
              const Spacer(),
              Icon(Icons.flag, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(task['priority'], style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }
}