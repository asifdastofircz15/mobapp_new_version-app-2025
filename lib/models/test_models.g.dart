// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestAdapter extends TypeAdapter<Test> {
  @override
  final int typeId = 0;

  @override
  Test read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Test(
      testId: fields[0] as String,
      candidateId: fields[1] as String,
      date: fields[2] as String,
      vehicleId: fields[3] as int,
      testNo: fields[4] as String,
      licenceNo: fields[5] as String,
      vehicleNo: fields[6] as String,
      route: fields[7] as String,
      startTime: fields[8] as String,
      endTime: fields[9] as String?,
      examinerId: fields[10] as String,
      remarks: (fields[11] as List).cast<int>(),
      note: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Test obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.testId)
      ..writeByte(1)
      ..write(obj.candidateId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.vehicleId)
      ..writeByte(4)
      ..write(obj.testNo)
      ..writeByte(5)
      ..write(obj.licenceNo)
      ..writeByte(6)
      ..write(obj.vehicleNo)
      ..writeByte(7)
      ..write(obj.route)
      ..writeByte(8)
      ..write(obj.startTime)
      ..writeByte(9)
      ..write(obj.endTime)
      ..writeByte(10)
      ..write(obj.examinerId)
      ..writeByte(11)
      ..write(obj.remarks)
      ..writeByte(12)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 1;

  @override
  Vehicle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vehicle(
      vehicleId: fields[0] as int,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.vehicleId)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RemarkAdapter extends TypeAdapter<Remark> {
  @override
  final int typeId = 2;

  @override
  Remark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Remark(
      remarkId: fields[0] as int,
      text: fields[1] as String,
      testId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Remark obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.remarkId)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.testId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
