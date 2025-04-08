import 'package:intl/intl.dart';

class Employee {
  final int id;
  final String name;
  final String designation;
  final String department;
  final String company;
  final String phone;
  final String email;
  final DateTime dateOfJoining;

  Employee({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.phone,
    required this.email,
    required this.company,
    required this.dateOfJoining,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      email: json["user"]['email'].toString(),
      name: json['name'].toString(),
      company: json["company"].toString(),
      department: json['department'].toString(),
      phone: json['mobile'].toString(),
      designation: json['designation'].toString(),
      dateOfJoining: DateTime.parse(json['date_of_joining']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'department': department,
      'phone': phone,
      'user': {'email': email},
      'company': company,
      'date_of_joining': DateFormat('yyyy-MM-DD').format(dateOfJoining),
    };
  }
}
