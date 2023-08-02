import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/Models/notes_model.dart';
import 'package:notebook/UI/HomePage.dart';
import 'package:notebook/cubit/note_book_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'Models/notebook_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  
  print(directory);
  await Hive.initFlutter(directory.path);


    // Adapter Generated by BuildRunner
    Hive.registerAdapter(NoteBookModelAdapter());

    // Adapter Generated by BuildRunner
    Hive.registerAdapter(NotesModelAdapter());


    // Opening the New Hive or Existing Database model
    await Hive.openBox<NoteBookModel>('NoteBooks');

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return BlocProvider<NoteBookCubit>(
      create: (context) => NoteBookCubit("Notebooks"),
      child: GetMaterialApp(home: const HomePage()),
    );
  }

}
