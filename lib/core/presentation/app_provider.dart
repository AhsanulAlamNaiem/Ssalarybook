import 'package:beton_book/core/domain/user.dart';
import 'package:beton_book/core/constants/appResources.dart';
import 'package:beton_book/features/punchInOut/location.dart';
import 'package:flutter/material.dart';

import '../domain/attendance.dart';


class AppProvider extends ChangeNotifier{
  String currentAppVersion = "0.0.0";
  List<Attendance> currentUsersAttendanceLog=[];
  Map<String, String> authHeader = {
    "cookie": "",
    "Authorization":  ""
  };
  User user = User(
      id: 0,
      name: "", designation: "", department: "",
      phone: "", email: "", company: "", dateOfJoining: "",
      locations: [],
      permissionGroups: []);

  updateUser({required User newUser}){
    user = newUser;
    notifyListeners();
  }

  updateCurrentUsersAttendance(List<Attendance> newAttendanceLog){
    currentUsersAttendanceLog = newAttendanceLog;
    notifyListeners();
  }

  updateAuthHeader({required newAuthHeader}){
    authHeader = newAuthHeader;
    notifyListeners();
  }

  fetchCurrentAppVersion({required fetchedVersion}){
    currentAppVersion = fetchedVersion;
    notifyListeners();
  }
}