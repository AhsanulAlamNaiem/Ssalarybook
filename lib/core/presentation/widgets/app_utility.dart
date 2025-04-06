import 'package:beton_book/core/constants/appResources.dart';
import 'package:beton_book/core/navigation/global_app_navigator.dart';
import 'package:flutter/material.dart';

class AppUtility{
  static final context =  GlobalNavigator.navigatorKey.currentContext;
  static  showToast({required String message, Color color = Colors.black54}){
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static  showToastAdvanced({required Widget content, Color color = Colors.white}){
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: content,
        backgroundColor: color,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}