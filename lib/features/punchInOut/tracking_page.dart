import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/presentation/widgets/app_utility.dart';
import 'package:beton_book/core/presentation/widgets/app_widgets.dart';
import 'package:beton_book/features/punchInOut/cloud_data.dart';
import 'package:beton_book/features/punchInOut/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/domain/response.dart';
import 'local_data.dart';


class TimeTracker extends StatefulWidget {
  const TimeTracker({super.key});

  @override
  _TimeTrackerPageState createState() => _TimeTrackerPageState();
}

class _TimeTrackerPageState extends State<TimeTracker> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => LocalData().getCurrentLocation());
    // print("0️⃣Did punched In: ${context.read<PunchingProvider>().didPunchIn}");
    // print("0️⃣Did punched In: ${context.read<AppProvider>().user!.didPunchinToday()}");
    // print("0️⃣Did punched In: ${context.read<AppProvider>().user.lastAttendanceId}");
    // print("0️⃣Did punched In: ${context.read<AppProvider>().user.lastAttendanceDate}");
  }

  @override
  Widget build(BuildContext context) {
    PunchingProvider provider = context.watch<PunchingProvider>();
    AppProvider globalProvider = context.watch<AppProvider>();
    String locationMessage = provider.locationMessage;
    bool didPunchIn =  globalProvider.user.didPunchinToday();
    bool isLoading = provider.isLoading;
    bool isClickable = provider.isClickable;
    bool isGettingLocation = provider.isGettingLocation;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(children: [
                    Text(DateFormat("EEEE, d MMMM").format(DateTime.now()), style: AppStyles.textH1),

                    _cardBuilder(
                        heading: [
                          Text("Current Location", style: AppStyles.textH1),
                          IconButton(onPressed: ()=>LocalData().getCurrentLocation(), icon: Icon(Icons.refresh))
                        ],
                        children: [
                          Text(
                            isGettingLocation? "Getting current Location .. .": locationMessage,
                            style: isGettingLocation ? null:AppStyles.textH3,),
                        ]
                    ),

                    isLoading || isGettingLocation?
                    AppWidgets.progressIndicator
                        : ElevatedButton(
                      style: AppStyles.elevatedButtonStyleFullWidth,
                      onPressed: isGettingLocation || (!isClickable)? null:() async{
                          provider.setLoadingStatus(true);
                          print(didPunchIn?"Punch Out":"Punch IN");
                        try {
                          FunctionResponse functionResponse =  didPunchIn ? await CloudData().punchOut() : await CloudData().punchIn();
                          AppUtility.showToast(functionResponse);
                        } catch(e){
                          print(e);
                          AppUtility.showToast(FunctionResponse(success: false, message: "System Error\n$e"));
                        }
                        provider.setLoadingStatus(false);
                      },
                      child: Text(
                          didPunchIn? "Punch Out":"Punch In", style: AppStyles.textOnMainColorheading),
                    ),
                  ],
                  ),
                ]
            )
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
}
