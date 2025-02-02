
import 'package:hive/hive.dart';

part 'candidate.g.dart';

@HiveType(typeId: 4)
class Candidate {
  @HiveField(0)
  String id;
  @HiveField(1)
  String lastName;
  @HiveField(2)
  String otherNames;
  @HiveField(3)
  String email;
  @HiveField(4)
  String nic;
  @HiveField(5)
  String address;
  @HiveField(6)
  String phone;
  @HiveField(7)
  String role;

  Candidate({
    required this.id,
    required this.lastName,
    required this.otherNames,
    required this.email,
    required this.nic,
    required this.address,
    required this.phone,
    required this.role,
  });

  factory Candidate.fromMap(Map<String, dynamic> data) {
    return Candidate(
      id: data['id'],
      lastName: data['lastName'] ?? '',
      otherNames: data['otherNames'] ?? '',
      email: data['email'] ?? '',
      nic: data['nic'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastName': lastName,
      'otherNames': otherNames,
      'email': email,
      'nic': nic,
      'address': address,
      'phone': phone,
      'role': role,
    };
  }
}
