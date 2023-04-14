import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({String? fName, String? lName, String? email, String? uId})
      : super(fName: fName, lName: lName, email: email, uId: uId);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fName: json['firstname'] ?? '',
      lName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      uId: json['uid'] ?? '',
    );
  }
}
