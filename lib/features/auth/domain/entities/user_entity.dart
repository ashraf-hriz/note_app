
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  String? fName;
  String? lName;
  String? email;
  String? uId;
  

  UserEntity({
    this.fName,
    this.lName,
    this.email,
    this.uId,
  });
  
  @override
  
  List<Object?> get props => [fName,lName,email,uId];
}