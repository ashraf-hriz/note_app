import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/strings/constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String fName, lName, String email, String password);
  bool isSignIn();
  Future<UserModel> getUserData();
  Future<Unit> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;

  AuthRemoteDataSourceImpl({required this.auth});

  @override
  Future<UserModel> getUserData() async {
    try {
      print('user uid ${auth.currentUser?.uid}');
      var documentSnapshot = await FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(auth.currentUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        print('user uid2 ${auth.currentUser?.uid}');
        return UserModel.fromJson(
            documentSnapshot.data() as Map<String, dynamic>);
      }else{
        throw NotFoundUserException();
      }
    } catch (e) {
      print('error currentuser ${e.toString()}');
      throw ServerException();
    }
    throw ServerException();
  }

  @override
  bool isSignIn() {
    if (auth.currentUser != null) {
      return true;
    }
    return false;
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      UserModel? userModel;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(user!.uid)
          .get();
      if (documentSnapshot.exists) {
        userModel =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        return userModel;
      }else{
         throw NotFoundUserException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw NotFoundUserException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
    } catch (e) {
      throw ServerException();
    }
    throw ServerException();
  }

  @override
  Future<UserModel> signUp(
      String fName, lName, String email, String password) async {
    try {
      UserModel? userModel;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      Map<String, dynamic> data = {
        'firstname': fName,
        'lastname': lName,
        'type': '',
        'email': email,
        'uid': user!.uid,
        'group': '',
      };
      await FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(user.uid)
          .set(data); // user data adding
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();
      if (documentSnapshot.exists) {
        userModel =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailExistException();
      }
    } catch (e) {
      throw ServerException();
    }
    throw ServerException();
  }
  
  @override
  Future<Unit> logOut() async{
    try{
       await auth.signOut();
       return Future.value(unit);
    }catch(e){
      throw ServerException();
    }
  }
}
