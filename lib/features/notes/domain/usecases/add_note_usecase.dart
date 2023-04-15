
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class AddNoteUsecase {
  final NotesRepository repository;

  AddNoteUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Note note) async {
    return await repository.addNote(note);
  }
}