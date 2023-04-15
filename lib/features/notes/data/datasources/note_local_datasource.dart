import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/local_database.dart';
import '../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getAllNotes();
  Future<Unit> deleteNote(String noteId);
  Future<Unit> updateNote(NoteModel noteModel);
  Future<Unit> addNote(NoteModel noteModel);
  Future<Unit> cashNotes(List<NoteModel> notesList);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  @override
  Future<Unit> addNote(NoteModel noteModel) async {
    try {
      var res = await DBHelper.insert(noteModel);
      print('add note res $res');
      return Future.value(unit);
    } catch (e) {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> deleteNote(String noteId) async {
    try {
      var res = await DBHelper.delete(noteId);
      print('delete note res $res');
      return Future.value(unit);
    } catch (e) {
      throw EmptyCacheException();
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    List<Map<String, dynamic>> notes = await DBHelper.query();
    return notes.map((data) => NoteModel.fromJson(data)).toList();
  }

  @override
  Future<Unit> updateNote(NoteModel noteModel) async {
    try {
      var res = await DBHelper.update(noteModel);
      print('delete note res $res');
      return Future.value(unit);
    } catch (e) {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> cashNotes(List<NoteModel> notesList) async {
    try {
      print('lent ${notesList.length}');
      for (int i = 0; i < notesList.length; i++) {
        //await DBHelper.delete(notesList[i].id);
        var res = await DBHelper.insert(notesList[i]);
        print('cash note $i $res');
      }
      return Future.value(unit);
    } catch (e) {
      print('cash error ${e.toString()}');
      throw EmptyCacheException();
    }
  }
}
