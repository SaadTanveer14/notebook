// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notebook_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteBookModelAdapter extends TypeAdapter<NoteBookModel> {
  @override
  final int typeId = 1;

  @override
  NoteBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteBookModel(
      title: fields[0] as String,
      notes: (fields[1] as List).cast<NotesModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, NoteBookModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
