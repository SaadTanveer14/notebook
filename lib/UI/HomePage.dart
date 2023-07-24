import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:notebook/Models/Boxes/boxes.dart';
import 'package:notebook/Models/key_value_model.dart';
import 'package:notebook/Models/notebook_model.dart';
import 'package:notebook/Models/notes_model.dart';
import 'package:notebook/UI/DeleteNoteBook.dart';
import 'package:notebook/UI/Notes.dart';
import 'package:notebook/cubit/note_book_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<String> _dropdownItems = ['Edit', 'Delete'];
  String _selectedItem = "";

  late List<String> noteBooks = [];
  
  List<KeyValueModel> notebooks = [] ; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: InkWell(
              onTap: () {
                _showCreateNotebookBottomSheet(context);
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
            height: Get.height*0.5,
            width: Get.width,
            child: BlocBuilder<NoteBookCubit, NoteBookState>(
              builder: (context, state) {
                if(state.noteBook.isNotEmpty)
                {
                   return ListView.builder(
                    itemCount: state.noteBook.length,
                    itemBuilder: (context, index) {
                       return Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => Notes());
                          },
                          onLongPress:(){
                            _showPopupMenu(context, state.noteBook[index]);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 240, 190, 207),
                            ),
                            child: Center(child: Text(state.noteBook[index]),),
                          ),
                        ),
                  );
                     }
                   );
                }
                return Text('No Notebook Found');
               
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          notebooks.clear();
          final box = Boxes.getData();

          final hiveMap = Boxes.getDataMap();

          for(var enteries in hiveMap.entries)
          {
            var key = enteries.key;
            var value = enteries.value;
            
            var keyValueModel = KeyValueModel(key: key, notebook: value);
              notebooks.add(keyValueModel);          
          }

          print(notebooks);


          for(int i =0 ; i< notebooks.length ; i++)
          {
            print(notebooks[i].key);
            box.delete(notebooks[i].key);

          }



          // print(hiveMap);


          
          // NoteBookModel noteBookModel =  NoteBookModel(title: "First NoteBook", notes: []); 
          // box.deleteAll();



/*           print(box.values.length);
          print(box.keys);

          final boxvalue = box.get(1);

          NotesModel notesModel = NotesModel(title: "First Notes", description: "Nothing");

          boxvalue!.notes.add(notesModel);

          print(boxvalue!.notes[0].title);
 */


          

          // print(box.)
      },
      child: Icon(Icons.add),
      )
    );
  }

  void _showPopupMenu(BuildContext context,String note_book) async {
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
      BlocProvider.of<NoteBookCubit>(context)
                          .deleteNoteBook(note_book);
     Get.snackbar("NoteBook", "Notebook named \"$note_book\" is deleted" );
    }

    else if (result == "Edit") {
      _showUpdateNotebookBottomSheet(context,note_book);
     Get.snackbar("NoteBook", "Notebook named \"$note_book\" is Updated" );
    }

    if (result != null) {
      setState(() {
        _selectedItem = result;
      });
    }
  }

  void _showCreateNotebookBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CreateNotebookBottomSheet();
      },
    );
  }

    void _showUpdateNotebookBottomSheet(BuildContext context, String noteBook){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return UpdateNotebookBottomSheet(noteBook : noteBook);
      },
    );
  }
}

class CreateNotebookBottomSheet extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Create Notebook",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilderTextField(
                  name: 'notebookName',
                  decoration: InputDecoration(
                    labelText: 'Notebook Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Notebook name is required.'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      // Perform your desired action with the form data
                      String notebookName =
                          _formKey.currentState!.fields['notebookName']!.value;

                      print("Notebook Name: $notebookName");

                      BlocProvider.of<NoteBookCubit>(context)
                          .createNewNoteBook(notebookName);

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
  String noteBook;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  UpdateNotebookBottomSheet({required this.noteBook});

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
                  name: 'newNoteBookName',
                  decoration: InputDecoration(
                    labelText: 'Notebook Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(
                      errorText: 'Notebook name is required.'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      // Perform your desired action with the form data
                      String newNoteBookName =
                          _formKey.currentState!.fields['newNoteBookName']!.value;

                      print("Notebook Name: $newNoteBookName");

                      BlocProvider.of<NoteBookCubit>(context)
                          .editNoteBook(noteBook,newNoteBookName);

                      Navigator.pop(context); // Close the bottom sheet
                    }
                  },
                  child: Text('Edit Note Book'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

