import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListEditor extends StatefulWidget {
  final String? todoId;
  final String? existingTask;
  final bool? existingDone;

  const ListEditor({super.key, this.todoId, this.existingTask, this.existingDone});

  @override
  State<ListEditor> createState() => _ListEditorState();
}

class _ListEditorState extends State<ListEditor> {
  final _taskController = TextEditingController();
  bool _done = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _taskController.text = widget.existingTask ?? '';
    _done = widget.existingDone ?? false;
  }

  void _saveTask() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final task = _taskController.text.trim();

    if (task.isEmpty || userId == null) return;

    setState(() => _isSaving = true);

    final data = {
      'task': task,
      'done': _done,
      'updatedAt': Timestamp.now(),
      'userId': userId,
    };

    try {
      if (widget.todoId != null) {
        await FirebaseFirestore.instance.collection('todos').doc(widget.todoId).update(data);
      } else {
        await FirebaseFirestore.instance.collection('todos').add(data);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }

    setState(() => _isSaving = false);
  }

  void _deleteTask() async {
    if (widget.todoId == null) return;

    try {
      await FirebaseFirestore.instance.collection('todos').doc(widget.todoId).delete();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Text(widget.todoId != null ? "Edit Task" : "New Task"),
        actions: [
          if (widget.todoId != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red,),
              onPressed: _deleteTask,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Task", labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text("Completed", style: TextStyle(color: Colors.white)),
              value: _done,
              onChanged: (val) => setState(() => _done = val ?? false),
              activeColor: Colors.blueAccent,
              checkColor: Colors.black,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveTask,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(widget.todoId != null ? "Update Task" : "Create Task"),
            ),
          ],
        ),
      ),
    );
  }
}

//ALLOW USER TO ADD A DEADLINE?