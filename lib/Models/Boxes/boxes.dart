import 'package:hive/hive.dart';
import 'package:notebook/Models/notebook_model.dart';

class Boxes{

  static Box<NoteBookModel> getData()=> Hive.box<NoteBookModel>('NoteBooks');

  static Map<dynamic, NoteBookModel> getDataMap() => Hive.box<NoteBookModel>('NoteBooks').toMap(); 
  
} 