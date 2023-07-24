import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'note_book_state.dart';

class NoteBookCubit extends Cubit<NoteBookState> {
  NoteBookCubit() : super(NoteBookState(noteBook: []));

  void createNewNoteBook(String note_book)
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

  }

}
