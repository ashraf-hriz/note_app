

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

import '../repositories/note_repository.dart';

class SyncNoteDataUsecase{
  final NotesRepository repository;

  SyncNoteDataUsecase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.syncNotesData();
  }
}