import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(),
            body:Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: InkWell(
                onTap: () {
                  
                },
                child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 240, 190, 207),
                    ),
                    child: Icon(Icons.add),
                ),
            ),
          ),
                  ],
                ),
    );
  }
}