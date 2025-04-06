import 'package:beton_book/core/domain/user.dart';
import 'package:beton_book/core/constants/appResources.dart';
import 'package:flutter/material.dart';


class AppProvider extends ChangeNotifier{
  User? user;
  Map<String, String> authHeader = {
    "cookie": "",
    "Authorization":  ""
  };
  String currentAppVersion = "0.0.0";

  updateUser({required User newUser}){
    user = newUser;
  }
  updateAuthHeader({required newAuthHeader}){
    authHeader = newAuthHeader;
  }

  fetchCurrentAppVersion({required fetchedVersion}){
    currentAppVersion = fetchedVersion;
  }
}