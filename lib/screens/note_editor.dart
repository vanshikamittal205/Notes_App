import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditor extends StatefulWidget {
  final String? noteId;
  final String? existingTitle;
  final String? existingContent;

  const NoteEditor({super.key, this.noteId, this.existingTitle, this.existingContent});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.existingTitle ?? '';
    _contentController.text = widget.existingContent ?? '';
  }

  Future<void> saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    setState(() => isSaving = true);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final notesRef = FirebaseFirestore.instance.collection('notes');

    if (widget.noteId != null) {
      // Update
      await notesRef.doc(widget.noteId).update({
        'title': title,
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(),

      });
    } else {
      // Create
      await notesRef.add({
        'title': title,
        'content': content,
        'userId': userId,
        'updatedAt': FieldValue.serverTimestamp(),

      });
    }

    setState(() => isSaving = false);
    Navigator.pop(context);
  }

  Future<void> deleteNote() async {
    if (widget.noteId != null) {
      await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).delete();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF121212),
    appBar: AppBar(
    backgroundColor: const Color(0xFF121212),
    elevation: 0,
    title: Text(widget.noteId != null ? 'Edit Note' : 'New Note', style: const TextStyle(color: Colors.white)),
    actions: [
    if (widget.noteId != null)
    IconButton(
    icon: const Icon(Icons.delete, color: Colors.redAccent),
    onPressed: deleteNote,
    )
    ],
    ),
    body: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
    children: [
    TextField(
    controller: _titleController,
    style: const TextStyle(color: Colors.white, fontSize: 18),
    decoration: const InputDecoration(
    hintText: 'Title',
    hintStyle: TextStyle(color: Colors.white38),
    border: InputBorder.none,
    ),
    ),
    const SizedBox(height: 10),
    Expanded(
    child: TextField(
    controller: _contentController,
    maxLines: null,
    expands: true,
    style: const TextStyle(color: Colors.white),
    decoration: const InputDecoration(
    hintText: 'Write your note here...',
    hintStyle: TextStyle(color: Colors.white38),
    border: InputBorder.none,
    ),
    ),
    ),
    ],
    ),
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: isSaving ? null : saveNote,
    backgroundColor: Colors.blueAccent,
    child: isSaving
        ? const CircularProgressIndicator(color: Colors.white)
        : const Icon(Icons.save),
    ),
    );
  }
}