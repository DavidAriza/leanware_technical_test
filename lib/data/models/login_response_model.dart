import 'package:leanware_test/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.id,
    required super.email,
    super.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        id: json['id'],
        email: json['email'],
        token: json['token'],
      );

  LoginResponseModel toEntity() {
    return LoginResponseModel(
      id: id,
      email: email,
      token: token,
    );
  }
}
