import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:notebook/Models/notes_model.dart';
import 'package:notebook/cubit/note_book_cubit.dart';

class Notes extends StatefulWidget {
  
  final List<NotesModel> notes;
  final int noteBookIndex;
  final NoteBookCubit noteBookCubit;


  const Notes({required this.noteBookCubit, required this.notes, required this.noteBookIndex});





  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  String _selectedItem = "";
  static const List<String> _dropdownItems = ['Edit', 'Delete'];
  
  void updateUI() {
    setState(() {

    });

    print("Parent UpdateUi called");
  }

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
                  
                  _showCreateNotebookBottomSheet(context,  widget.noteBookCubit, widget.noteBookIndex);

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

              Container(
                height: Get.height * 0.5,
                width: Get.width,
                child: widget.notes.isNotEmpty ? ListView.builder(
                    itemCount: widget.notes.length,
                    itemBuilder: (context, index){
                      final note = widget.notes[index];
                      return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: InkWell(
                          onTap: () {

                          },
                          onLongPress:(){
                            _showPopupMenu(context, index);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 240, 190, 207),
                            ),
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(note.title),
                                Text(note.description)
                              ],
                            ),),
                          ),
                        ),
                      );
                    }
                  )
                  :
                  const Text("No Notes Found")
              )
            ],
          ),
    );
  }
  
  void _showPopupMenu(BuildContext context,int index) async {
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 0, 0, 0),
      items: _dropdownItems.map((item) {
        return PopupMenuItem<String>(
          value: item, 
          child: Text(item),
        );
      }).toList(),
    );

    print(result);

    if (result == "Delete") {
      // BlocProvider.of<NoteBookCubit>(context)
      //                     .removeNotebookAt(index);

    widget.noteBookCubit.removeNotesAt(widget.noteBookIndex, index);

    setState(() {
      
    });

     Get.snackbar("NoteBook", "Notebook  is deleted" );
    }

    else if (result == "Edit") {
      _showUpdateNotebookBottomSheet(context, index);
     Get.snackbar("NoteBook", "Notebook is Updated" );
    }

    if (result != null) {
      setState(() {
        _selectedItem = result;
      });
    }
  }

  void _showCreateNotebookBottomSheet(BuildContext context, NoteBookCubit noteBookCubit, int noteBookIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CreateNotebookBottomSheet(updateUI: updateUI, noteBookCubit: noteBookCubit, noteBookIndex: noteBookIndex);
      },
    );
  }

    void _showUpdateNotebookBottomSheet(BuildContext context, int index){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return UpdateNotebookBottomSheet(updateUI: updateUI, noteBookCubit: widget.noteBookCubit, noteBookIndex: widget.noteBookIndex, notesIndex : index);
      },
    );
  }
}







class CreateNotebookBottomSheet extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final noteBookCubit;
  final noteBookIndex;

  CreateNotebookBottomSheet({ required this.updateUI, required this.noteBookCubit, required this.noteBookIndex});

  final VoidCallback updateUI;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Create Notes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilderTextField(
                  name: 'noteName',
                  decoration: InputDecoration(
                    labelText: 'Note Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Note name is required.'),
                ),
                FormBuilderTextField(
                  name: 'noteDescription',
                  decoration: InputDecoration(
                    labelText: 'Note Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Note description is required.'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      // Perform your desired action with the form data
                      String noteName =
                          _formKey.currentState!.fields['noteName']!.value;


                      String noteDescription =
                          _formKey.currentState!.fields['noteDescription']!.value;

                      print("Note Name: $noteName\n Description: $noteDescription");

                      noteBookCubit.addNotes(noteBookIndex, noteName, noteDescription);
                      /* BlocProvider.of<NoteBookCubit>(context)
                          .addNoteBook(notebookName); */
                      updateUI();
                      Navigator.pop(context); // Close the bottom sheet
                    }
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class UpdateNotebookBottomSheet extends StatelessWidget {
  final noteBookCubit;
  final noteBookIndex;
  final notesIndex;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  UpdateNotebookBottomSheet({required this.updateUI, required this.noteBookCubit, required this.noteBookIndex, required this.notesIndex});

  final VoidCallback updateUI;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Edit Notebook",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 FormBuilderTextField(
                  name: 'noteName',
                  decoration: InputDecoration(
                    labelText: 'Note Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Note name is required.'),
                ),
                FormBuilderTextField(
                  name: 'noteDescription',
                  decoration: InputDecoration(
                    labelText: 'Note Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Note description is required.'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      // Perform your desired action with the form data
                      String noteName =
                          _formKey.currentState!.fields['noteName']!.value;


                      String noteDescription =
                          _formKey.currentState!.fields['noteDescription']!.value;

                      print("Note Name: $noteName\n Description: $noteDescription");

                      noteBookCubit.editNotesAt(noteBookIndex, notesIndex, noteName, noteDescription);

                      updateUI();
                      Navigator.pop(context); // Close the bottom sheet
                    }
                  },
                  child: Text('Edit Note'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}