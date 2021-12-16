// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String userType;
  final String imageProfile;
  final String token;
  UserModel({
    this.name,
    this.email,
    this.password,
    this.userType,
    this.imageProfile,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
      'imageProfile': imageProfile,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      userType: (map['userType'] ?? '') as String,
      imageProfile: (map['imageProfile'] ?? '') as String,
      token: (map['token'] ?? '') as String,
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
