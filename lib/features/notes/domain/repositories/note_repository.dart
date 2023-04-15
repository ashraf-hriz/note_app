
import 'package:dartz/dartz.dart';
import 'package:note_app/features/notes/domain/entities/note_entity.dart';

import '../../../../core/error/failures.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getAllNotes();
  Future<Either<Failure, Unit>> deleteNote(String id);
  Future<Either<Failure, Unit>> updateNote(Note note);
  Future<Either<Failure, Unit>> addNote(Note note);
  Future<Either<Failure, Unit>> syncNotesData();
}