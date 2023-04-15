
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class UpdateNoteUsecase {
  final NotesRepository repository;

  UpdateNoteUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Note note) async {
    return await repository.updateNote(note);
  }
}