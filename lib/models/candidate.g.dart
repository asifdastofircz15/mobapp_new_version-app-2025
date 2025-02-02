// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CandidateAdapter extends TypeAdapter<Candidate> {
  @override
  final int typeId = 4;

  @override
  Candidate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Candidate(
      id: fields[0] as String,
      lastName: fields[1] as String,
      otherNames: fields[2] as String,
      email: fields[3] as String,
      nic: fields[4] as String,
      address: fields[5] as String,
      phone: fields[6] as String,
      role: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Candidate obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.otherNames)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.nic)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CandidateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
