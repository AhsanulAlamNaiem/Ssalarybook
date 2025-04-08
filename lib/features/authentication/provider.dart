import 'package:flutter/material.dart';


class AuthenticationProvider extends ChangeNotifier{
  bool isLoading = false;

  setLoadingState(bool state){
    isLoading = state;
    notifyListeners();
  }
}