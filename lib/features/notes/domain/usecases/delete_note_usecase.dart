
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

import '../repositories/note_repository.dart';

class DeleteNoteUsecase {
  final NotesRepository repository;

  DeleteNoteUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String noteId) async {
    return await repository.deleteNote(noteId);
  }
}