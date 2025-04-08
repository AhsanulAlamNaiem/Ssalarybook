import 'package:beton_book/core/domain/employee.dart';
import 'package:beton_book/features/punchInOut/location.dart';
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
        [
          {"longitude": 0.0000, "latitude": 0.0000, "id": "Not a company location"}
        ];
    final locationsListOfLocations = locationsListOfObject
        .map((json) {
      print(json);
      return Location(
          longitude: json["longitude"],
          latitude: json["latitude"],
          branch_id: json["id"]);
    })
        .toList()
        .cast<Location>();
    final data_Of_Joining = json['date_of_joining'];

    return User(
      id: json['id'],
      name: json['name'].toString(),
      designation: json['designation'].toString(),
      department: json['department'].toString(),
      phone: json['phone'].toString(),
      email: json['email'].toString(),
      company: json["company"].toString(),
      dateOfJoining: data_Of_Joining!=null? DateTime.parse(data_Of_Joining): DateTime.now(),
      // locations: locationsListOfLocations,
      permissionGroups: json["group-name"] ?? [],
      lastAttendanceDate: json['lastAttendanceDate'] != null
          ? DateTime.parse(json['lastAttendanceDate'])
          : null,
      lastAttendanceId: json['lastAttendanceId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    // json['locations'] = locations.map((loc) => loc.toJson()).toList();
    json['group-name'] = permissionGroups;
    json['lastAttendanceDate'] =
        lastAttendanceDate?.toIso8601String(); // Serializing new property
    json['lastAttendanceId'] = lastAttendanceId; // Serializing new property
    return json;
  }

  // New method
  bool didPunchinToday() {
    return lastAttendanceId != null && isToday(lastAttendanceDate!);
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void punchedIn(int attendanceId) {
    lastAttendanceDate = DateTime.now();
    lastAttendanceId = attendanceId;
  }
}