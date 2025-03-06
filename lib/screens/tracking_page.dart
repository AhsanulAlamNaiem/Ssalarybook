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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                Text("Saturday, 23 January", style: AppStyles.textH1),
                Text("Start Time: 8:57 AM", style: AppStyles.textH1),
              ],),
              Text(""),
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
              [CircularProgressIndicator()]:
              [
                Text(_locationMessage, style: AppStyles.textH3,),
                Text("\nDistance From Office:\n${double.parse(distance.toStringAsFixed(2))} Metre", style: AppStyles.textH3,),
              ]
              ),
              // Text(""),
              // ElevatedButton(onPressed: ()=>_punchIn(), child: Text("PunchIn")),
              // ElevatedButton(onPressed: ()=>_punchOut(), child: Text("PunchOut")),
              // ElevatedButton(onPressed: ()async{
              //   final data = await storage.read(key: AppSecuredKey.didPunchIn);
              //   print(data);
              // }, child: Text("read")),
              isLoading?CircularProgressIndicator(): ElevatedButton(
                style: AppStyles.elevatedButtonStyleFullWidth,
                onPressed: isGettingLocation? null:() async{

                  print(didPunchIn?"Punch Out":"Punch IN");
                  didPunchIn? await _punchOut(): await _punchIn();
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading!=null? Row( children: heading):Text(""),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.grey),),
            elevation: 0,
            color: Colors.transparent,

            child: Container(
              constraints: BoxConstraints(
                minHeight: 140.0, // Set your desired minimum height
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children),
              ),
            ),
          )
        ]);
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
      return;
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


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
    print(user.locations[0].longitude);
    print(user.locations[0].latitude);

    final url = Uri.parse(AppApis.punchIn);
    final body = jsonEncode(
        {
          // "entry_latitude": "${position!.latitude}",
          "entry_latitude": "${user.locations[0].latitude}",
          // "entry_longitude": "${position!.longitude}",
          "entry_longitude": "${user.locations[0].longitude}"
        }
    );

    print(body);
    Map<String, String> headers = authHeaders!;
    headers['Content-Type'] = 'application/json';
    final response = await http.post(url, body: body, headers:  headers);
    print(headers);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("writing");
      storage.write(key: AppSecuredKey.didPunchIn, value:  jsonEncode({"attendanceId": "true", "date": DateFormat('yyyy-MM-dd').format(DateTime.now())}));
      print("written");

      final message = data["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
      didPunchIn=true;
      });
    } else if (response.statusCode ==400){
      final responseJson = jsonDecode(response.body);
      final message = '${responseJson['error']['message']?? "Something went wrong"}\n\n ${responseJson['error']['details']??"Try again later"}';

      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              behavior: SnackBarBehavior.floating,
            ),
          );
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

    final user = context.read<AppProvider>().user!;
    print(user.locations[0].longitude);
    print(user.locations[0].latitude);

     final url = Uri.parse(AppApis.punchOut);
    final body = jsonEncode(
        {
          // "exit_latitude": "${position!.latitude}",
          "exit_latitude": "${user.locations[0].latitude}",
          // "exit_longitude": "${position!.longitude}",
          "exit_longitude": "${user.locations[0].longitude}"
        }
    );

    print(body);
    Map<String, String> headers = authHeaders!;
    headers['Content-Type'] = 'application/json';
    final response = await http.post(url, body: body, headers: headers);
    print(headers);
    print(response.statusCode  );
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final message = data["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      await storage.delete(key: AppSecuredKey.didPunchIn);
      setState(() {
      didPunchIn=false;
      });
    } else if (response.statusCode ==400){
      final responseJson = jsonDecode(response.body);
      final message = '${responseJson['error']['message']?? "Something went wrong"}\n\n ${responseJson['error']['details']??"Try again later"}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  _checkPunchedInOrNot()async{
    final attendanceId = await storage.read(key: AppSecuredKey.didPunchIn);
    print("attendence: $attendanceId");
    if(attendanceId!=null) {
      final attendanceIdjson = jsonDecode(attendanceId);
      final date = attendanceIdjson["date"];
      if(date == DateFormat('yyyy-MM-dd').format(DateTime.now())){
        didPunchIn=true;
      } else{
        didPunchIn = false;
      }
    } else{
      didPunchIn=false;
    }
    setState(() {
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
