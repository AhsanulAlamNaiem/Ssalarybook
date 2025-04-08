import 'package:beton_book/core/domain/user.dart';
import 'package:beton_book/core/constants/appResources.dart';
import 'package:beton_book/core/navigation/global_app_navigator.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PunchingProvider extends ChangeNotifier{

  String locationMessage = "No location Found";
  Position? position;
  bool isGettingLocation = true;
  double distance = 10000;
  bool didPunchIn = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>().user!.didPunchinToday();
  bool isLoading = false;
  bool isClickable = true;
  Map<String, String>? authHeaders;
  int? lastAttendanceId;
  int? lastAttendanceDate;
  // User? user = GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>().user!;

  // void setLastAttendanceID(String? id){
  //   if(id!=null) {
  //     locationMessage = id;
  //     didPunchIn= true;
  //   }
  //   notifyListeners();
  // }

  // Update location message
  void setLocationMessage(String message) {
  locationMessage = message;
  notifyListeners();
  }

  // Update position
  void setPosition(Position? newPosition) {
  position = newPosition;
  notifyListeners();
  }

  // Update getting location status
  void setGettingLocationStatus(bool status) {
  isGettingLocation = status;
  isLoading = status;
  notifyListeners();
  }

  // Update distance
  void setDistance(double newDistance) {
  distance = newDistance;
  notifyListeners();
  }


  // Update punch-in confirmation
  void setDidPunchIn(bool status, {int? attendanceId}) {
    if(status && attendanceId != null ){
    GlobalNavigator.navigatorKey.currentContext!.read<AppProvider>().user!.punchedIn(attendanceId);
    lastAttendanceId = attendanceId;
    } else if(status && attendanceId != null){
      throw Exception("If status True, You must provide attendanceId");
    }
    didPunchIn = status;
    notifyListeners();
  }

  // Update loading status
  void setLoadingStatus(bool status) {
  isLoading = status;
  notifyListeners();
  }

  // Update clickable status
  void setClickableStatus(bool status) {
  isClickable = status;
  notifyListeners();
  }

  // Update authentication headers
  void setAuthHeaders(Map<String, String>? headers) {
  authHeaders = headers;
  notifyListeners();
  }
  }
