import 'package:note_app/core/error/exceptions.dart';
import 'package:note_app/features/auth/domain/entities/user_entity.dart';

import 'package:note_app/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, UserEntity>> getUserData() async {
    if (await networkInfo.isConnected) {
      try {
        var data = await remoteDataSource.getUserData();
        return Right(data);
      } on NotFoundUserException {
        return Left(NotFoundUserFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  bool isSignIn() {
    return remoteDataSource.isSignIn();
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        var data = await remoteDataSource.signIn(email, password);
        return Right(data);
      } on ServerException {
        return Left(ServerFailure());
      } on NotFoundUserException {
        return Left(NotFoundUserFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      String fName, lName, String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        var data = await remoteDataSource.signUp(fName, lName, email, password);
        return Right(data);
      } on ServerException {
        return Left(ServerFailure());
      } on WeakPasswordException {
        return Left(WeakPasswordFailure());
      } on EmailExistException {
        return Left(EmailExistFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logOut() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logOut();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
