import 'dart:convert';

class User {
  final String? token;
  final String id;
  final String username;
  final String email;

  User({this.token, required this.id, required this.username, required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'token': token, 'id': id, 'username': username, 'email': email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      token: map['token'] != null ? map['token'] as String : null,
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
