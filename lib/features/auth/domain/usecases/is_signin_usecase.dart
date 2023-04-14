
import '../repositories/auth_repository.dart';

class IsSignInUseCase{

  final AuthRepository authRepository;
  IsSignInUseCase({required this.authRepository});

  bool call(){
    return authRepository.isSignIn();
  }
}