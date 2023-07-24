import 'package:flutter/material.dart';

class DeleteNoteBook extends StatefulWidget {
  const DeleteNoteBook({super.key});

  @override
  State<DeleteNoteBook> createState() => _DeleteNoteBookState();
}

class _DeleteNoteBookState extends State<DeleteNoteBook> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: const Text('Delete NoteBook'),
          ),
          body: const Center(
              child: Text('Delete NoteBook'),
            ),
    );
  }
}