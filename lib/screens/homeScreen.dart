import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_ily/screens/profile_page.dart';
import '../widgets/cards.dart';
import 'Notifications_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_ily/services/toggling.dart';


Future<String> getUserName(String userId) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (doc.exists && doc.data()!.containsKey('name')) {
    return doc['name'];
  } else {
    return "User";
  }
}

Future<int> getNoteCount(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('notes')
      .where('userId', isEqualTo: userId)
      .get();
  return snapshot.size;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId= FirebaseAuth.instance.currentUser?.uid;
    final _taskService= TaskService();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('todos')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!.docs;
          final totalTasks = tasks.length;
          final completedTasks = tasks
              .where((doc) => doc['done'] == true)
              .length;
          final completionRate = totalTasks == 0 ? 0 : (completedTasks /
              totalTasks * 100).round();
          final pendingTasks = tasks.where((doc) => doc['done'] == false)
              .toList();

          // Nest FutureBuilder inside
          return FutureBuilder<int>(
            future: getNoteCount(userId!), // userId already defined above
            builder: (context, noteSnapshot) {
              if (!noteSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final totalNotes = noteSnapshot.data!;

          return Scaffold(
            appBar: AppBar(
              //name of the user should be displayed
              title: FutureBuilder<String>(
                future: getUserName(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Hello...');
                  } else if (snapshot.hasError) {
                    return const Text('Hello');
                  } else {
                    return Text('Hello ${snapshot.data}');
                  }
                },
              )
              ,
              toolbarHeight: 100,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  // some space at the end
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 16,
                      child: Icon(Icons.person, color: Colors.white, size: 16),
                    ),
                  ),
                ),


                IconButton(

                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage()),
                    );
                  },
                  ),
                  IconButton(
                  icon: const Icon(Icons.logout),
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Logout")),
                      ],
                    ),
                  );

                  if (shouldLogout ?? false) {
                    await FirebaseAuth.instance.signOut();
                    try {
                      await GoogleSignIn().signOut();
                    } catch (_) {}

                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },

                  ),
              ],),

            backgroundColor: const Color(0xFF121212),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text("Today's Progress",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                //completed task and total tasks to be determined dynamically
                                Text(
                                    "You have completed $completedTasks of the $totalTasks tasks,\nkeep up the progress!!",
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                           CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,

                            // percentage of pending tasks should be computed dynamically
                            child: Text("$completionRate",
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HomeCard(
                          title: 'Notes',
                          subtitle: '$totalNotes',
                          icon: Icons.sticky_note_2,
                          onTap: () {
                            Navigator.pushNamed(context, '/notes');
                          },
                        ),
                        const SizedBox(width: 16),
                        HomeCard(
                          title: 'To-do List',
                          subtitle: '$totalTasks',
                          icon: Icons.sticky_note_2,
                          onTap: () {
                            Navigator.pushNamed(context, '/to_do_list');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Pending Tasks",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text("See All",
                            style: TextStyle(color: Colors.blueAccent))
                      ],
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pendingTasks.length,
                      itemBuilder: (context, index){
                        final task= pendingTasks[index];
                        return Column(
                          children: [
                            buildTaskCard(
                              task['task'],
                              "Today",
                              task['done'],
                                  () {
                                _taskService.toggleTaskDone(
                                  taskId: task.id,                // this is VERY IMPORTANT
                                  currentStatus: task['done'],
                                  userId: task['userId'],
                                );
                              },
                            ),
                            const SizedBox(height: 10,),
                          ],
                        );
                      }
                    )
                  ],
                ),
              ),
            ),
          );
        },
    );
        }
    );
  }

  Widget buildTaskCard(
      String title,
      String deadline,
      bool _done,
      VoidCallback onToggleDone,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: _done ? Colors.greenAccent : Colors.white,
                        fontSize: 16,
                        decoration: _done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
                const SizedBox(height: 4),
                Text("Deadline: $deadline",
                    style:
                    const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: onToggleDone,
            icon: Icon(
              _done ? Icons.check_circle : Icons.circle_outlined,
              color: _done ? Colors.greenAccent : Colors.white54,
            ),
          ),

        ],
      ),
    );
  }

}
