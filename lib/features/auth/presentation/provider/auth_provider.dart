import 'package:flutter/material.dart';
import 'package:note_app/features/auth/domain/usecases/get_userdata_usecase.dart';
import 'package:note_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:note_app/features/auth/presentation/screens/login_screen.dart';
import 'package:note_app/features/notes/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/helper.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/utils/snackbar_message.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/is_signin_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  String? selectedGroup;

  final IsSignInUseCase isSignInUseCase;
  final GetUserDataUseCase getUserDataUseCase;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final LogOutUseCase logOutUseCase;
  AuthProvider({
    required this.isSignInUseCase,
    required this.getUserDataUseCase,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.logOutUseCase,
  });

  UserEntity? userModel;
  bool _loading = true;

  bool get loading => _loading;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  signIn() async {
    loading = true;
    var failureOrUser =
        await signInUseCase(emailController.text, passwordController.text);

    failureOrUser.fold((failure) {
      String message = _mapFailureToMessage(failure);
      SnackBarMessage().showErrorSnackBar(message: message, context: navigatorKey.currentState!.context);
    }, (user) {
      userModel = user;
       pushAndRemoveUntil(navigatorKey.currentState!.context,
              const HomeScreen(), false);
      //SnackBarMessage().showSuccessSnackBar(message: 'succcess login', context: navigatorKey.currentState!.context);
    });
    loading = false;
  }

  signUp() async {

     loading = true;
    var failureOrUser =
        await signUpUseCase(fNameController.text,
        lNameController.text,
        emailController.text,
        passwordController.text,);

    failureOrUser.fold((failure) {
      String message = _mapFailureToMessage(failure);
      SnackBarMessage().showErrorSnackBar(message: message, context: navigatorKey.currentState!.context);
    }, (user) {
      userModel = user;
      //SnackBarMessage().showSuccessSnackBar(message: 'success signup', context: navigatorKey.currentState!.context);
       pushAndRemoveUntil(navigatorKey.currentState!.context,
              const HomeScreen(), false);
    });
    loading = false;
  }

  getUserData() async {

    var failureOrUser =
        await getUserDataUseCase();

    failureOrUser.fold((failure) {
      //String message = _mapFailureToMessage(failure);
      //SnackBarMessage().showErrorSnackBar(message: message, context: navigatorKey.currentState!.context);
    }, (user) {
      userModel = user;
       
    });
    
  }

  bool isSignIn() {
    return isSignInUseCase();
  }

  logOut() async {
   loading = true;
    var failureOrUnit =
        await logOutUseCase();

    failureOrUnit.fold((failure) {
      String message = _mapFailureToMessage(failure);
      SnackBarMessage().showErrorSnackBar(message: message, context: navigatorKey.currentState!.context);
    }, (_) {
      
       pushAndRemoveUntil(
                navigatorKey.currentState!.context, const LoginPage(),false);
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
      case WeakPasswordFailure:
        return WEAK_PASSWORD_FAILURE_MESSAGE;
      case NotFoundUserFailure:
        return USER_NOT_FOUND_FAILURE_MESSAGE;
      case EmailExistFailure:
        return EMAIL_NOT_EXIST_FAILURE_MESSAGE;
      case WrongPasswordFailure:
        return WRONG_PASSORD_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}

UserEntity get currentUser =>
    Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false)
        .userModel!;
