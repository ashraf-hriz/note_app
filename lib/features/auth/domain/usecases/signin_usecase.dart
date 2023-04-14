
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase{
  final AuthRepository authRepository;
  SignInUseCase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call(String email, String password) async{
    return await authRepository.signIn(email,password);
  }
}