// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthCredentialModelAdapter extends TypeAdapter<AuthCredentialModel> {
  @override
  final int typeId = 5;

  @override
  AuthCredentialModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthCredentialModel(
      token: fields[0] as int?,
      accessToken: fields[1] as String?,
      signInMethod: fields[2] as String,
      providerId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthCredentialModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.signInMethod)
      ..writeByte(3)
      ..write(obj.providerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCredentialModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
