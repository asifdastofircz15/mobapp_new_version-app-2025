import 'package:hive/hive.dart';

part 'test_models.g.dart';

@HiveType(typeId: 0)
class Test {
  @HiveField(0)
  final String testId;

  @HiveField(1)
  final String candidateId;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final int vehicleId;

  @HiveField(4)
  final String testNo;

  @HiveField(5)
  final String licenceNo;

  @HiveField(6)
  final String vehicleNo;

  @HiveField(7)
  final String route;

  @HiveField(8)
  final String startTime;

  @HiveField(9)
  final String? endTime;

  @HiveField(10)
  final String examinerId;

  @HiveField(11)
  final List<int> remarks;

  @HiveField(12)
  final String? note;

  Test({
    required this.testId,
    required this.candidateId,
    required this.date,
    required this.vehicleId,
    required this.testNo,
    required this.licenceNo,
    required this.vehicleNo,
    required this.route,
    required this.startTime,
    required this.endTime,
    required this.examinerId,
    required this.remarks,
    this.note
  });

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      testId: map['test_id'],
      candidateId: map['candidate_id'],
      date: map['date'],
      vehicleId: map['vehicle_id'],
      testNo: map['test_no'],
      licenceNo: map['licence_no'],
      vehicleNo: map['vehicle_no'],
      route: map['route'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      examinerId: map['examiner_id'],
      remarks: List<int>.from(map['remarks'] ?? []),
      note: map['note']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'test_id': testId,
      'candidate_id': candidateId,
      'date': date,
      'vehicle_id': vehicleId,
      'test_no': testNo,
      'licence_no': licenceNo,
      'vehicle_no': vehicleNo,
      'route': route,
      'startTime': startTime,
      'endTime': endTime,
      'examiner_id': examinerId,
      'remarks': remarks,
      'note': note
    };
  }
}

@HiveType(typeId: 1)
class Vehicle {
  @HiveField(0)
  final int vehicleId;

  @HiveField(1)
  final String description;

  Vehicle({
    required this.vehicleId,
    required this.description,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      vehicleId: map['vehicle_id'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicle_id': vehicleId,
      'description': description,
    };
  }
}

@HiveType(typeId: 2)
class Remark {
  @HiveField(0)
  final int remarkId;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String testId;

  Remark({
    required this.remarkId,
    required this.text,
    required this.testId,
  });

  factory Remark.fromMap(Map<String, dynamic> map) {
    return Remark(
      remarkId: map['remark_id'],
      text: map['text'],
      testId: map['test_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'remark_id': remarkId,
      'text': text,
      'test_id': testId,
    };
  }
}
