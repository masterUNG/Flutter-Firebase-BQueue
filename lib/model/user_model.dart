import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String userType;
  final String imageProfile;
  UserModel({
     this.name,
     this.email,
     this.password,
     this.userType,
     this.imageProfile,
  });
  

  UserModel copyWith({
    String name,
    String email,
    String password,
    String userType,
    String imageProfile,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      imageProfile: imageProfile ?? this.imageProfile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
      'imageProfile': imageProfile,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      userType: map['userType'],
      imageProfile: map['imageProfile'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, password: $password, userType: $userType, imageProfile: $imageProfile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.name == name &&
      other.email == email &&
      other.password == password &&
      other.userType == userType &&
      other.imageProfile == imageProfile;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      userType.hashCode ^
      imageProfile.hashCode;
  }
}
