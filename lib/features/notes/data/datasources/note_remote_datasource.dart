import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/core/error/exceptions.dart';

import '../../../../core/utils/local_database.dart';
import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getAllNotes();
  Future<Unit> deleteNote(String noteId);
  Future<Unit> updateNote(NoteModel noteModel);
  Future<Unit> addNote(NoteModel noteModel);
  Future<Unit> syncAllNoteData();
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  @override
  Future<Unit> addNote(NoteModel noteModel) async {
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .doc(noteModel.id)
        .set(noteModel.toJson())
        .catchError((e) {
      print(e.toString());
      throw ServerException();
    });
    return Future.value(unit);
  }

  @override
  Future<Unit> deleteNote(String noteId) async {
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .doc(noteId)
        .delete()
        .catchError((e) {
      print(e.toString());
      throw ServerException();
    });
    return Future.value(unit);
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    var data = await FirebaseFirestore.instance
        .collection("Notes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .get();

    return data.docs.map((data) => NoteModel.fromJson(data.data())).toList();
  }

  @override
  Future<Unit> updateNote(NoteModel noteModel) async {
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .doc(noteModel.id)
        .set(noteModel.toJson())
        .catchError((e) {
      print(e.toString());
      throw ServerException();
    });
    return Future.value(unit);
  }

  @override
  Future<Unit> syncAllNoteData() async {
    List<Map<String, dynamic>> notes = await DBHelper.query();

    var notesList = notes.map((data) => NoteModel.fromJson(data)).toList();
    print('sync ${notesList.length}');
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    for (int i = 0; i < notesList.length; i++) {
      await FirebaseFirestore.instance
          .collection("Notes")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notes")
          .doc(notesList[i].id)
          .set(notesList[i].toJson())
          .catchError((e) {
        print(e.toString());
        throw ServerException();
      });
    }
    return Future.value(unit);
  }
}
