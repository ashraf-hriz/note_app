import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/helper.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snackbar_message.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_all_note_usecase.dart';
import '../../domain/usecases/sync_note_data.dart';
import '../../domain/usecases/update_note_usecase.dart';

class NoteProvider extends ChangeNotifier {
  final GetAllNoteUsecase getAllNoteUsecase;
  final AddNoteUsecase addNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;
  final UpdateNoteUsecase updateNoteUsecase;
  final SyncNoteDataUsecase syncNoteDataUsecase;

  NoteProvider({
    required this.getAllNoteUsecase,
    required this.addNoteUsecase,
    required this.deleteNoteUsecase,
    required this.updateNoteUsecase,
    required this.syncNoteDataUsecase,
  });

  bool _loading = true;

  bool get loading => _loading;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  List<Note> notesList = [];

  getAllNotes({bool showLoading = true}) async {
    if (showLoading) loading = true;
    final failureOrNotes = await getAllNoteUsecase();
    failureOrNotes.fold((failure) {
      String message = _mapFailureToMessage(failure);
      SnackBarMessage().showErrorSnackBar(
          message: message, context: navigatorKey.currentState!.context);
    }, (notes) {
      notesList = notes.toList();
    });

    if (showLoading) loading = false;
  }

  deleteNote(String noteId) async {
    loading = true;
    final failureOrDeleted = await deleteNoteUsecase(noteId);
    failureOrDeleted.fold((failure) {
      String message = _mapFailureToMessage(failure);
      SnackBarMessage().showErrorSnackBar(
          message: message, context: navigatorKey.currentState!.context);
    }, (_) {
      SnackBarMessage().showSuccessSnackBar(
          message: DELETE_SUCCESS_MESSAGE, context: navigatorKey.currentState!.context);
      getAllNotes();
      Navigator.of(navigatorKey.currentState!.context).pop();
    });

    loading = false;
  }

  updateNote(Note note) async {
    loading = true;
    final failureOrUpdated = await updateNoteUsecase(note);
    failureOrUpdated.fold((failure) {
      String message = _mapFailureToMessage(failure);
      SnackBarMessage().showErrorSnackBar(
          message: message, context: navigatorKey.currentState!.context);
    }, (_) {
      SnackBarMessage().showSuccessSnackBar(
          message: UPDATE_SUCCESS_MESSAGE, context: navigatorKey.currentState!.context);
      getAllNotes();
      Navigator.of(navigatorKey.currentState!.context).pop();
    });

    loading = false;
  }

  addNote(Note note) async {
    loading = true;
    final failureOrAdded = await addNoteUsecase(note);
    failureOrAdded.fold((failure) {
      String message = _mapFailureToMessage(failure);
      SnackBarMessage().showErrorSnackBar(
          message: message, context: navigatorKey.currentState!.context);
    }, (_) {
      SnackBarMessage().showSuccessSnackBar(
          message: ADD_SUCCESS_MESSAGE, context: navigatorKey.currentState!.context);
      getAllNotes();
      Navigator.of(navigatorKey.currentState!.context).pop();
    });

    loading = false;
  }

  syncNoteData()async{
    final failureOrSynced = await syncNoteDataUsecase();
    failureOrSynced.fold((failure) {
      
      SnackBarMessage().showErrorSnackBar(
          message: ERROR_OCCUARED, context: navigatorKey.currentState!.context);
    }, (_) {
      SnackBarMessage().showSuccessSnackBar(
          message: SYNC_SUCCESS_MESSAGE, context: navigatorKey.currentState!.context);
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;

      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
