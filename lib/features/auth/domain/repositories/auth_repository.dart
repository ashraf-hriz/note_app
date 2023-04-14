import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(
      String fName, lName, String email, String password);
  bool isSignIn();
  Future<Either<Failure, UserEntity>> getUserData();
  Future<Either<Failure, Unit>> logOut();
}
