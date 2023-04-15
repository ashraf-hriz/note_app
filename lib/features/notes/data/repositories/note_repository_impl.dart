import 'package:dartz/dartz.dart';
import 'package:note_app/features/notes/data/datasources/note_local_datasource.dart';
import 'package:note_app/features/notes/data/datasources/note_remote_datasource.dart';
import 'package:note_app/features/notes/data/models/note_model.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/note_entity.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class NotesRepositoryImpl implements NotesRepository {
  final NoteRemoteDataSource remoteDataSource;
  final NoteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NotesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    if (await networkInfo.isConnected) {
      try {
        final notes = await remoteDataSource.getAllNotes();
        await localDataSource.cashNotes(notes);
        notes.sort((a, b) {
          var adate = a.date;
          var bdate = b.date;
          return bdate.compareTo(adate);
        });
        return Right(notes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final notes = await localDataSource.getAllNotes();
        notes.sort((a, b) {
          var adate = a.date;
          var bdate = b.date;
          return bdate.compareTo(adate);
        });
        return Right(notes);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addNote(Note note) async {
    final NoteModel noteModel = NoteModel(
        id: note.id, text: note.text, title: note.title, date: note.date);

    /* return await _getMessage(() {
      return localDataSource.addNote(noteModel);
    }); */

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addNote(noteModel);
        await localDataSource.addNote(noteModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.addNote(noteModel);
        return const Right(unit);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNote(String noteId) async {
    /* return await _getMessage(() {
      return localDataSource.deleteNote(noteId);
    }); */
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteNote(noteId);
        await localDataSource.deleteNote(noteId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.deleteNote(noteId);
        return const Right(unit);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updateNote(Note note) async {
    final NoteModel noteModel = NoteModel(
        id: note.id, text: note.text, title: note.title, date: note.date);

    /* return await _getMessage(() {
      return localDataSource.updateNote(noteModel);
    }); */

    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateNote(noteModel);
        await localDataSource.updateNote(noteModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.updateNote(noteModel);
        return const Right(unit);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
  
  @override
  Future<Either<Failure, Unit>> syncNotesData() async{
     if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.syncAllNoteData();
       
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else{
      return Left(OfflineFailure());
    }
  }
}
