import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepository;
  SignUpUseCase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call(
      String fName, dynamic lName, String email, String password) async {
    return await authRepository.signUp(fName, lName, email, password);
  }
}
