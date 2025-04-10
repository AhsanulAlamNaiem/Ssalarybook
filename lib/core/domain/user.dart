import 'dart:convert';

import 'package:beton_book/core/domain/employee.dart';
import 'package:beton_book/features/punchInOut/location.dart';

import '../Local_Data_Manager/cacheClient.dart';
import '../Local_Data_Manager/cacheKeys.dart';
class User extends Employee {
  // final List<Location> locations;
  final List permissionGroups;
  DateTime? lastAttendanceDate; // New property
  int? lastAttendanceId; // New property

  User({
    required int id,
    required String name,
    required String designation,
    required String department,
    required String phone,
    required String email,
    required String company,
    required DateTime dateOfJoining,
    // required this.locations,
    required this.permissionGroups,
    this.lastAttendanceDate, // Initializing new property
    this.lastAttendanceId, // Initializing new property
  }) : super(
    id: id,
    name: name,
    designation: designation,
    department: department,
    phone: phone,
    email: email,
    company: company,
    dateOfJoining: dateOfJoining,
  );

  factory User.fromJson(Map<String, dynamic> json) {

    final locationsListOfObject = json["locations"] ??
        [{"longitude": 0.0000, "latitude": 0.0000, "id": "Not a company location"}];
    final locationsListOfLocations = locationsListOfObject.map((json) {
      return Location(
          longitude: json["longitude"],
          latitude: json["latitude"],
          branch_id: json["id"]);
    }).toList().cast<Location>();

    final data_Of_Joining = json['date_of_joining'];



    return User(
      id: json['id'],
      name: json['name'].toString(),
      designation: json['designation'].toString(),
      department: json['department'].toString(),
      phone: json['phone'].toString(),
      email: json['email'].toString(),
      company: json["company"].toString(),
      dateOfJoining: _safeDateTimeParse(data_Of_Joining)??DateTime(1970,1,1),
      permissionGroups: json["group-name"] ?? [],
      lastAttendanceDate:_safeDateTimeParse(json['last_attendance_date']),
      lastAttendanceId: json['last_attendance_check'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    // json['locations'] = locations.map((loc) => loc.toJson()).toList();
    json['group-name'] = permissionGroups;
    json['last_attendance_date'] =
        lastAttendanceDate?.toIso8601String(); // Serializing new property
    json['last_attendance_check'] = lastAttendanceId; // Serializing new property
    return json;
  }

  // New method
  bool didPunchinToday() {
    if(_isToday(lastAttendanceDate, lastAttendanceId)){ // let user punch in, not punched in today yet.
      if(lastAttendanceId!=null){
        return true;
      } else{
        return false;
      }
    }else { //user may be punched ut today, show him punch in button
      return false;
    }
  }

  void punchedIn() {
    lastAttendanceDate = DateTime.now();
    lastAttendanceId = 1;
    CacheClient.write(key: CacheKeys.userObject, value: jsonEncode(toJson()));
  }
  void punchedOut() {
    lastAttendanceDate = DateTime.now();
    lastAttendanceId = null;
    CacheClient.write(key: CacheKeys.userObject, value: jsonEncode(toJson()));
  }
}

bool _isToday(DateTime? date, int? id) {
  final now = DateTime.now();
  if(date==null) return false;
  bool istoday = date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
print("is today: $istoday");
return istoday;
}

 _safeDateTimeParse(String? date) {
  if (date == null) return null;
  try {
    return DateTime.parse(date);
  } catch (e) {
    print('Invalid date format: $date'); // Logs invalid date
    DateTime(1970,1,1); // Handle gracefully
  }
}

