import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ===========================================================================
// 1. THE TASK MODEL (Type Safety)
// ===========================================================================
class Task {
  final String id;
  final String tag;
  final Color tagColor;
  final String title;
  final String description;
  final int progressCurrent;
  final int progressTotal;
  final String priority; // 'Low', 'Medium', 'High'
  final List<String> avatars;

  Task({
    required this.id,
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.description,
    required this.progressCurrent,
    required this.progressTotal,
    required this.priority,
    required this.avatars,
  });
}

class AllProjectsScreen extends StatefulWidget {
  const AllProjectsScreen({super.key});

  @override
  State<AllProjectsScreen> createState() => _AllProjectsScreenState();
}

class _AllProjectsScreenState extends State<AllProjectsScreen> {
  // ===========================================================================
  // 2. DATA SOURCES
  // ===========================================================================
  
  // Column 1: In Work
  List<Task> inWorkProjects = [
    Task(
      id: "1",
      tag: "New Project",
      tagColor: Colors.amber,
      title: "Mobile App Design",
      description: "Redesigning the main dashboard",
      progressCurrent: 4,
      progressTotal: 10,
      priority: "High",
      avatars: ['https://i.pravatar.cc/150?img=11', 'https://i.pravatar.cc/150?img=3'],
    ),
    Task(
      id: "2",
      tag: "Dev",
      tagColor: Colors.blueAccent,
      title: "API Integration",
      description: "Connecting to the backend",
      progressCurrent: 2,
      progressTotal: 10,
      priority: "Medium",
      avatars: ['https://i.pravatar.cc/150?img=3'],
    ),
  ];

  // Column 2: Completed
  List<Task> completedProjects = [
    Task(
      id: "3",
      tag: "Design",
      tagColor: Colors.purple,
      title: "User Persona",
      description: "Creating user profiles",
      progressCurrent: 10,
      progressTotal: 10,
      priority: "Low",
      avatars: ['https://i.pravatar.cc/150?img=5'],
    ),
  ];

  // ===========================================================================
  // 3. DRAG AND DROP LOGIC
  // ===========================================================================
  
  void _onDrop(Task task, String targetStatus) {
    setState(() {
      // 1. Remove from wherever it was
      inWorkProjects.removeWhere((t) => t.id == task.id);
      completedProjects.removeWhere((t) => t.id == task.id);

      // 2. Add to new destination
      if (targetStatus == "IN WORK") {
        inWorkProjects.insert(0, task);
      } else if (targetStatus == "COMPLETED") {
        completedProjects.insert(0, task);
      }
    });
  }

  // ===========================================================================
  // 4. ADD TASK LOGIC (POPUP DIALOG)
  // ===========================================================================
  void _showAddTaskDialog(BuildContext context, String status) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController tagController = TextEditingController();
    String selectedPriority = 'Low';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Add to $status", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Task Title",
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagController,
              decoration: InputDecoration(
                labelText: "Tag (e.g. Design)",
                prefixIcon: const Icon(Icons.label),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => selectedPriority = val!,
              decoration: InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4AC1A0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    tag: tagController.text.isEmpty ? "General" : tagController.text,
                    tagColor: Colors.blue, // Default color
                    title: titleController.text,
                    description: "No description added",
                    progressCurrent: 0,
                    progressTotal: 5,
                    priority: selectedPriority,
                    avatars: ['https://i.pravatar.cc/150?img=${DateTime.now().second % 10}'],
                  );

                  if (status == "IN WORK") inWorkProjects.add(newTask);
                  else completedProjects.add(newTask);
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Create Task", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 5. MAIN UI BUILD
  // ===========================================================================

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
        title: Text("Kanban Board", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
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
  // 6. COLUMN & CARD BUILDERS
  // ===========================================================================

  Widget _buildKanbanColumn({required String title, required List<Task> tasks, required String status}) {
    // Width logic: On tablet take 350px, on mobile take 75% of screen
    double width = MediaQuery.of(context).size.width > 600 ? 350 : MediaQuery.of(context).size.width * 0.75;

    return DragTarget<Task>(
      onWillAccept: (data) => true,
      onAccept: (data) => _onDrop(data, status),
      builder: (context, candidateData, rejectedData) {
        bool isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          decoration: BoxDecoration(
            color: isHovering ? Colors.blue.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isHovering ? Border.all(color: Colors.blue.withOpacity(0.5)) : Border.all(color: Colors.transparent),
          ),
          child: Column(
            children: [
              // --- HEADER WITH ADD BUTTON ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700])),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                          child: Text("${tasks.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.grey[600],
                      tooltip: "Add Task",
                      onPressed: () => _showAddTaskDialog(context, status),
                    ),
                  ],
                ),
              ),

              // --- LIST AREA ---
              Expanded(
                child: tasks.isEmpty 
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(8),
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

  Widget _buildEmptyState() {
    return Center(
      child: DottedBorderBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download_rounded, color: Colors.grey[300], size: 40),
            const SizedBox(height: 5),
            Text("Drop here", style: TextStyle(color: Colors.grey[300])),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableCard(Task task) {
    return LongPressDraggable<Task>(
      data: task,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Transform.rotate(
        angle: 0.05,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Opacity(opacity: 0.9, child: _buildCardContent(task, isDragging: true)),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
          child: _buildCardContent(task),
        ),
      ),
      child: _buildCardContent(task),
    );
  }

  Widget _buildCardContent(Task task, {bool isDragging = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDragging 
          ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]
          : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: task.tagColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.tag, 
                  style: TextStyle(color: task.tagColor, fontSize: 10, fontWeight: FontWeight.bold)
                ),
              ),
              const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          Text(task.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(task.description, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: task.progressCurrent / task.progressTotal,
              minHeight: 4,
              backgroundColor: Colors.grey[100],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4AC1A0)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 24,
                child: Stack(
                  children: [
                    if (task.avatars.isNotEmpty)
                       Positioned(left: 0, child: CircleAvatar(radius: 10, backgroundImage: NetworkImage(task.avatars[0]))),
                    if (task.avatars.length > 1)
                       Positioned(left: 15, child: CircleAvatar(radius: 10, backgroundImage: NetworkImage(task.avatars[1]))),
                  ],
                ),
              ),
              const Spacer(),
              Icon(Icons.flag, size: 14, color: task.priority == "High" ? Colors.red : Colors.grey[400]),
              const SizedBox(width: 4),
              Text(task.priority, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }
}

// Simple Helper for Empty State Dotted Border
class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1, style: BorderStyle.solid), // Simplified for standard flutter
      ),
      child: child,
    );
  }
}