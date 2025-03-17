import 'package:beton_book/services/appResources.dart';
import 'package:flutter/material.dart';


class AppProvider extends ChangeNotifier{
  User? user;

  updateUser({required User newUser}){
    user = newUser;
  }
}