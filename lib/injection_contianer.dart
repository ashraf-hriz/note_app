import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:note_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:note_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:note_app/features/notes/data/datasources/note_local_datasource.dart';
import 'package:note_app/features/notes/data/datasources/note_remote_datasource.dart';
import 'package:note_app/features/notes/data/repositories/note_repository_impl.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/remote_datasource.dart';
import 'features/auth/domain/usecases/get_userdata_usecase.dart';
import 'features/auth/domain/usecases/is_signin_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/signin_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/notes/domain/usecases/add_note_usecase.dart';
import 'features/notes/domain/usecases/delete_note_usecase.dart';
import 'features/notes/domain/usecases/get_all_note_usecase.dart';
import 'features/notes/domain/usecases/sync_note_data.dart';
import 'features/notes/domain/usecases/update_note_usecase.dart';
import 'features/notes/presentation/provider/note_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - notes

// Provider

  sl.registerFactory(() => AuthProvider(
        getUserDataUseCase: sl(),
        isSignInUseCase: sl(),
        logOutUseCase: sl(),
        signInUseCase: sl(),
        signUpUseCase: sl(),
      ));

  sl.registerFactory(() => NoteProvider(
        getAllNoteUsecase: sl(),
        updateNoteUsecase: sl(),
        deleteNoteUsecase: sl(),
        addNoteUsecase: sl(),
        syncNoteDataUsecase: sl(),
      ));

// Usecases

  sl.registerLazySingleton(() => GetUserDataUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => IsSignInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogOutUseCase(authRepository: sl()));

  sl.registerLazySingleton(() => GetAllNoteUsecase(sl()));
  sl.registerLazySingleton(() => UpdateNoteUsecase(sl()));
  sl.registerLazySingleton(() => DeleteNoteUsecase(sl()));
  sl.registerLazySingleton(() => AddNoteUsecase(sl()));
  sl.registerLazySingleton(() => SyncNoteDataUsecase(sl()));

// Repository

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));

  sl.registerLazySingleton<NotesRepository>(() => NotesRepositoryImpl(
      networkInfo: sl(), localDataSource: sl(), remoteDataSource: sl()));

// Datasources

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(auth: sl()));

  sl.registerLazySingleton<NoteLocalDataSource>(
      () => NoteLocalDataSourceImpl());

  sl.registerLazySingleton<NoteRemoteDataSource>(
      () => NoteRemoteDataSourceImpl());

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
