import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:notebook/Models/notebook_model.dart';
import 'package:notebook/Models/notes_model.dart';

part 'note_book_state.dart';

class NoteBookCubit extends Cubit<List<NoteBookModel>> {
  String boxName;

  NoteBookCubit(this.boxName) : super([]){
    loadNoteNooks();
  }


  void loadNoteNooks()
  {
    final box = Hive.box<NoteBookModel>(boxName);
    emit(box.values.toList());
  }


  void addNoteBook(String noteBookName) {

    NoteBookModel noteBook = NoteBookModel(title: noteBookName, notes: []);
    final box = Hive.box<NoteBookModel>(boxName);
    box.add(noteBook);
    print(box.values);
    emit(box.values.toList());

  }

  
  void removeNotebookAt(int index) {
    final box = Hive.box<NoteBookModel>(boxName);
    box.deleteAt(index);

    box.getAt(index);
    emit(box.values.toList());
  }

  void updateNotebookAt(int index, String newnotebook) {
    final box = Hive.box<NoteBookModel>(boxName);
    
    final notebook = box.getAt(index);

    notebook!.title = newnotebook;

    box.putAt(index, notebook);

    
    emit(box.values.toList());
  }


  void addNotes(int index, String title, String description){

      final box = Hive.box<NoteBookModel>(boxName);
      final notebook = box.getAt(index);
      
      NotesModel note = NotesModel(title: title, description: description);

      notebook!.notes.add(note);
      print(notebook.notes);
      notebook.save();
      emit(box.values.toList());

  }

  void removeNotesAt(int noteBookIndex, int noteIndex){
    final box = Hive.box<NoteBookModel>(boxName);
    final notebook = box.getAt(noteBookIndex);

    notebook!.notes.removeAt(noteIndex);
    print(notebook.notes);
    notebook.save();
    emit(box.values.toList());


  }


  void editNotesAt(int noteBookIndex, int noteIndex, String title, String description){
    final box = Hive.box<NoteBookModel>(boxName);
    final notebook = box.getAt(noteBookIndex);
    
    notebook!.notes[noteIndex].title =title;
    notebook.notes[noteIndex].description =description;

    notebook.save();

    emit(box.values.toList());

  }

/*   void createNewNoteBook(String note_book)
  {
    List<String> newNoteBooks = [...state.noteBook, note_book];

    emit(NoteBookState(noteBook: newNoteBooks));
  }

  void deleteNoteBook(String note_book)
  {

    List<String> newNoteBooks = state.noteBook.where((element) => element!= note_book).toList();

    emit(NoteBookState(noteBook: newNoteBooks));
  }

  void editNoteBook(String note_book, String new_note_book) {

    // store index of the notebook

    int index = state.noteBook.indexOf(note_book);

    // update the note_book new_note_book

    state.noteBook[index] = new_note_book;

     emit(NoteBookState(noteBook: state.noteBook));

  } */

}
