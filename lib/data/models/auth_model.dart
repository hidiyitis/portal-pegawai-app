import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:portal_pegawai_app/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.accessTokenExpiredAt,
    super.refreshTokenExpiredAt,
    required UserModel super.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      accessTokenExpiredAt: json['access_token_expired_at'],
      refreshTokenExpiredAt: json['refresh_token_expired_at'] ?? "",
      user: UserModel.fromJson(json['user']),
    );
  }
}
