import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:note_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:note_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/remote_datasource.dart';
import 'features/auth/domain/usecases/get_userdata_usecase.dart';
import 'features/auth/domain/usecases/is_signin_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/signin_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/provider/auth_provider.dart';

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

// Usecases

  sl.registerLazySingleton(() => GetUserDataUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => IsSignInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogOutUseCase(authRepository: sl()));

// Repository

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));

// Datasources

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(auth: sl()));

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
