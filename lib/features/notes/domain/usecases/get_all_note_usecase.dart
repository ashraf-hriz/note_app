
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetAllNoteUsecase {
  final NotesRepository repository;

  GetAllNoteUsecase(this.repository);

  Future<Either<Failure, List<Note>>> call() async {
    return await repository.getAllNotes();
  }
}