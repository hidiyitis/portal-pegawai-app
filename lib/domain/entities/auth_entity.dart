import 'package:portal_pegawai_app/domain/entities/user_entity.dart';

class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final String accessTokenExpiredAt;
  final String? refreshTokenExpiredAt;
  final UserEntity user;

  AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.accessTokenExpiredAt,
    this.refreshTokenExpiredAt,
  });
}
