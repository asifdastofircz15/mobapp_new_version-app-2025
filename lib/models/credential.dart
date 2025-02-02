import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

part 'credential.g.dart';

@HiveType(typeId: 5)
class AuthCredentialModel {
  @HiveField(0)
  final int? token;
  @HiveField(1)
  final String? accessToken;
  @HiveField(2)
  final String signInMethod;
  @HiveField(3)
  final String providerId;

  AuthCredentialModel({
    required this.token,
    required this.accessToken,
    required this.signInMethod,
    required this.providerId,
  });

  factory AuthCredentialModel.fromJson(Map<String, dynamic> json) {
    return AuthCredentialModel(
      token: json['token'] as int,
      accessToken: json['accessToken'] as String,
      signInMethod: json['signInMethod'] as String,
      providerId: json['providerId'] as String,
    );
  }

  factory AuthCredentialModel.fromAuthCredential(AuthCredential credential) {
    return AuthCredentialModel(
      token: credential.token,
      accessToken: credential.accessToken,
      signInMethod: credential.signInMethod,
      providerId: credential.providerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'accessToken': accessToken,
      'signInMethod': signInMethod,
      'providerId': providerId,
    };
  }
}
