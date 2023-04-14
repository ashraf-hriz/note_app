
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetUserDataUseCase{
  final AuthRepository authRepository;
  GetUserDataUseCase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call() async{
    return await authRepository.getUserData();
  }
}