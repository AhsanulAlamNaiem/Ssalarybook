import 'dart:convert';

import 'package:beton_book/core/Local_Data_Manager/cacheClient.dart';
import 'package:beton_book/core/domain/user.dart';
import 'package:flutter/material.dart';
import '../Local_Data_Manager/cacheKeys.dart';
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
      phone: "", email: "", company: "", dateOfJoining: DateTime.now(),
      permissionGroups: []);

  updateUser({required User newUser}){
    user = newUser;
    notifyListeners();
    print("user Updated in provider");
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