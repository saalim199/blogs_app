// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogs_app/core/common/user.dart';

class UserModel extends User {
  final String? password;
  final String? confirmPassword;
  UserModel({
    super.token,
    this.confirmPassword,
    this.password,
    required super.id,
    required super.username,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
    );
  }

  UserModel copyWith({String? token, String? id, String? username, String? email}) {
    return UserModel(
      token: token ?? this.token,
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}
