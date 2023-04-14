
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LogOutUseCase{
  final AuthRepository authRepository;

  LogOutUseCase({required this.authRepository});

  Future<Either<Failure,Unit>> call() async{
    return await authRepository.logOut();
  }
}