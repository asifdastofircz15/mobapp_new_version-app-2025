// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthInfoAdapter extends TypeAdapter<AuthInfo> {
  @override
  final int typeId = 6;

  @override
  AuthInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthInfo(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as DateTime,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.idToken)
      ..writeByte(2)
      ..write(obj.idRefresh)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
