import 'dart:core';
import 'package:hive/hive.dart';
part 'personal_info.g.dart';

@HiveType(typeId: 6)
class AuthInfo extends HiveObject {
  @HiveField(0)
  String? email;
  @HiveField(1)
  String? idToken;
  @HiveField(2)
  String? idRefresh;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  String role;
  @HiveField(5)
  String uid;

  AuthInfo(this.email, this.idToken, this.idRefresh, this.createdAt, this.role, this.uid);
}
