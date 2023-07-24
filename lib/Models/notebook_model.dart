import 'package:hive/hive.dart';
import 'package:notebook/Models/notes_model.dart';
part 'notebook_model.g.dart';


@HiveType(typeId: 1)
class NoteBookModel extends HiveObject{
  @HiveField(0)
  String title;

  @HiveField(1)
  List<NotesModel> notes;


  NoteBookModel({required this.title, required this.notes});

}