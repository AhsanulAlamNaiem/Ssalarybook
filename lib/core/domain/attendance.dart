import 'dart:convert';
import 'package:intl/intl.dart';

class Attendance {
  final int id;
  final int employee;
  final String punchInTime;
  final String punchOutTime;
  final String status;
  final DateTime date;

  Attendance({
    required this.id,
    required this.employee,
    required this.punchInTime,
    required this.punchOutTime,
    required this.status,
    required this.date,
  });

  // Factory method to create an Attendance object from JSON
  factory Attendance.fromJson(Map<dynamic, dynamic> json) {
    // print(json);
    // print("from model: ${json['id']}");

    DateTime timeIn = DateTime.parse(json['time_in']??'1990-01-01').add(Duration(hours: 6));
    DateTime timeOut = DateTime.parse(json['time_out']??'1990-01-01').add(Duration(hours: 6));

    print(timeIn);
    print(timeOut);
    DateTime date = DateTime.parse(json['date']);

    Attendance att = Attendance(
      id: json['id'],
      employee: json['employee'],
      punchInTime: DateFormat.jm().format(timeIn),
      punchOutTime: DateFormat.jm().format(timeOut),
      status: json['status'],
      date:  date,
    );
    return att;
  }

  static List<Attendance> fromJsonList(String jsonString){
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Attendance.fromJson(json)).toList();
  }
}
