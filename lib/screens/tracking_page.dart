import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beton_book/services/appResources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/scretResources.dart';
import 'package:intl/intl.dart';


class TimeTracker extends StatefulWidget {
  const TimeTracker({super.key});

  @override
  _TimeTrackerPageState createState() => _TimeTrackerPageState();
}

class _TimeTrackerPageState extends State<TimeTracker> {
  String? qrCodeValue;
  bool isScanning = true;
  final storage = FlutterSecureStorage();
  final securedDesignation = "designation";
  bool isScanned = false;
  String _locationMessage = "No location Found";
  Position? position;
  bool isGettingLocation = false;
  double distance = 10000;
  bool canPunchIn = false;
  bool didPunchIn = false;
  bool isLoading = false;
  bool isClickable = true;
  Map<String, String>?  authHeaders;

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    _checkPunchedInOrNot();
    _getAuthHeaders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                Text(DateFormat("EEEE, d MMMM").format(DateTime.now()), style: AppStyles.textH1),
                // Text("Start Time: 8:57 AM", style: AppStyles.textH1),
              ],),
              // _cardBuilder(
              //     children: [
              //       Text("HH:MM:SS", style: TextStyle(fontSize: 16)),
              //       SizedBox(height: 8),
              //       Text(
              //         "02:44:21",
              //         style: TextStyle(
              //             fontSize: 24, fontWeight: FontWeight.bold),
              //       ),
              //     ]),

              _cardBuilder(
                  heading: [
                    Text("Current Location", style: AppStyles.textH1),
                    IconButton(onPressed: (){_getCurrentLocation();}, icon: Icon(Icons.refresh))
                  ], children: isGettingLocation?
              [Column(children: [
                // CircularProgressIndicator(),
                Text("Getting current Location .. .")
              ],)]:
              [
                Text(_locationMessage, style: AppStyles.textH3,),
                // Text("\nDistance From Office:\n${double.parse(distance.toStringAsFixed(2))} Metre", style: AppStyles.textH3,),
              ]
              ),
              // Text(""),
              // ElevatedButton(onPressed: ()=>_punchIn(), child: Text("PunchIn")),
              // ElevatedButton(onPressed: ()=>_loadAttendance(), child: Text("load")),
              // ElevatedButton(onPressed: ()=>_punchOut(), child: Text("PunchOut")),
              // ElevatedButton(onPressed: ()async{
              //   final data = await storage.read(key: AppSecuredKey.didPunchIn);
              //   print(data);
              // }, child: Text("read")),
              isLoading || isGettingLocation?AppWidgets.progressIndicator: ElevatedButton(
                style: AppStyles.elevatedButtonStyleFullWidth,
                onPressed: isGettingLocation || (!isClickable)? null:() async{

                  print(didPunchIn?"Punch Out":"Punch IN");
                  try {
                    didPunchIn ? await _punchOut() : await _punchIn();
                  } catch(e){
                    setState(() {
                      isClickable = false;
                      isLoading = false;
                    });
                    AppUtility.showToast(message: "SomeThing Went Wrong! Check Internet Connection.");
                  }
                },
                child: Text(
                    didPunchIn? "Punch Out":"Punch In", style: AppStyles.textOnMainColorheading),
              ),
            ],
          ),
        )
    );
  }


  Widget _cardBuilder({List<Widget>? heading, required List<Widget> children}) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.grey),
        ),
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 140.0, // Set your desired minimum height
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  heading!=null? Row( crossAxisAlignment: CrossAxisAlignment.center, children: heading):Text(""),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children),
                ]),
          ),
        )
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isGettingLocation = true;
    });
    User user = context.read<AppProvider>().user!;
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      setState(() {
        _locationMessage = "Permission Denied";
      });
      setState(() {
        isClickable = false;
        isGettingLocation = false;
      });
      return;
    }

    try{
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch(e){
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print("Service $serviceEnabled");
      if(!serviceEnabled){
        _locationMessage = "Location is Disabled";
        setState(() {
          isClickable = false;
          isGettingLocation = false;
        });
      }
      return;
    }


    if(position!=null){
      distance = Geolocator.distanceBetween(
        position!.latitude,
        position!.longitude,
        user.locations[0].latitude,
        user.locations[0].longitude,
      );

      setState(() {
        isGettingLocation = false;
        isGettingLocation = false;
        _locationMessage =
        'Latitude: ${position!.latitude},\nLongitude: ${position!.longitude}';
        if (distance < 100) canPunchIn = true;
      });
    }
  }
  // punch in >>>>>>>>>>>>>>>>>>>>>>>
  Future<void> _punchIn() async{
    setState(() {
      isLoading = true;
    });

    final user = context.read<AppProvider>().user!;
    print("User Locaton:");
    user.locations.forEach((loc)=>print("${loc.longitude} - ${loc.latitude} - ${loc.branch_id}"));

    final url = Uri.parse(AppApis.punchIn);
    final body = jsonEncode(
        {
          "entry_latitude": "${position!.latitude}",
          "entry_longitude": "${position!.longitude}",
        }
    );
    print(body);
    Map<String, String> headers = authHeaders!;
    headers['Content-Type'] = 'application/json';
    final response = await http.post(url, body: body, headers:  headers);
    print(headers);
    print(response.body);
    print(response.statusCode);

    try{
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("writing");
      storage.write(key: AppSecuredKey.didPunchIn, value:  jsonEncode({"attendanceId": "true", "date": DateFormat('yyyy-MM-dd').format(DateTime.now())}));
      print("written");

      final message = data["message"];
      AppUtility.showToast(message: message);
      setState(() {
        didPunchIn=true;
      });
    } else if (response.statusCode ==400){
      final responseJson = jsonDecode(response.body);
      final message = '${responseJson['error']['message']?? "Something went wrong"}\n\n ${responseJson['error']['details']??"Try again later"}';

      AppUtility.showToast(message: message);

    } else{
      AppUtility.showToast(message: "SomeThing Went Wrong! Check Internet Connection.");
    }} catch(e){
      AppUtility.showToast(message: "SomeThing Went Wrong! \\$e");
    }
    setState(() {
      isLoading = false;
    });
  }
  // PunchOut Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> _punchOut() async{
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(AppApis.punchOut);
    final body = jsonEncode(
        {
          "exit_latitude": "${position!.latitude}",
          "exit_longitude": "${position!.longitude}",
        }
    );

    print(body);
    Map<String, String> headers = authHeaders!;
    headers['Content-Type'] = 'application/json';

    try{
    final response = await http.post(url, body: body, headers: headers);
    print(headers);
    print(response.statusCode  );
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final message = data["message"];
      AppUtility.showToast(message: message);

      await storage.delete(key: AppSecuredKey.didPunchIn);
      setState(() {
        didPunchIn=false;
      });
    } else if (response.statusCode ==400){
      final responseJson = jsonDecode(response.body);
      final message = '${responseJson['error']['message']?? "Something went wrong"}\n\n ${responseJson['error']['details']??"Try again later"}';

      AppUtility.showToast(message: message);

    }else{
      AppUtility.showToast(message: " ${response.statusCode}${response.statusCode==500?" - server Eror":""} - Something Went Wrong");

    }
    } catch(e){
      AppUtility.showToast(message: "SomeThing Went Wrong! Check Internet Connection.");
    }
    setState(() {
      isLoading = false;
    });
  }

  _checkPunchedInOrNot()async{
    _loadAttendance();
  }

  void _loadAttendance() async{
    setState(() {
      isLoading = true;
    });
    final user = context.read<AppProvider>().user;
    final url = "${AppApis.attendanceLog}?employee=${user!.id}";
    print(url);
    try{
    final response = await http.get(Uri.parse(url));
    print(response.body);
    final attendanceJson = jsonDecode(response.body);
    print("${response.statusCode} ${response.body}");
    if(response.statusCode==200){
      if(attendanceJson.length==0){
        didPunchIn = false;
      } else {
        var maxIdObject = attendanceJson.reduce((curr, next) =>
        curr['id'] > next['id'] ? curr : next);
        print("Last Attendence id: $maxIdObject");
        didPunchIn = maxIdObject["time_out"] == null;
      }}} catch(e){
      isClickable = false;
      AppUtility.showToast(message: "SomeThing Went Wrong! Check Internet Connection.");
    }
    print(didPunchIn);
    setState(() {
      isLoading = false;
    });
  }

  _getAuthHeaders()async{
    final token = await storage.read(key: AppSecuredKey.token);
    print("token $token");
    final tokenjson = jsonDecode(token!);
    authHeaders = {"cookie": tokenjson['cookie'],
      "Authorization":  tokenjson['Authorization']
    };
  }
}
