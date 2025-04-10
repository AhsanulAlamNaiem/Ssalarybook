import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier{
  bool isLoading = true;
  List companies = [];

  setLoadingState(bool state){
    isLoading = state;
    notifyListeners();
  }

  updateCompanies(List newCompanies){
    companies = newCompanies;
    notifyListeners();
  }
}
