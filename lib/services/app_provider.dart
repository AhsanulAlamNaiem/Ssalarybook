import 'package:flutter/material.dart';


class AppProvider extends ChangeNotifier{
  String? qrCode;
  bool isScanning = true;
  bool isPatching = false;
  Map? machine;
  String? model;
  List<Map<String, dynamic>> notifications = [];
  int index = 0;
  String? designation;


  updateDesignation({ required String newDesignation}){
    designation = newDesignation;
    notifyListeners();
  }

  updateQrCodeValue({ required String qrCodeValue}) async{
    qrCode = qrCodeValue;
    model = qrCodeValue;
    notifyListeners();
  }

  updateScannerState({ required bool scanningState}) async{
    isScanning = scanningState;
    notifyListeners();
  }

  updateMachineData(Map newMachine) async{
    machine = newMachine;
  }

  updateMachineDatawithOutNotification(Map newMachine) async{
    machine = newMachine;
  }


  updatePatchingState(bool patchingState){
    isPatching = patchingState;
    notifyListeners();
  }


  setIndex(int newIndex){
    index = newIndex;
    notifyListeners();
  }

}