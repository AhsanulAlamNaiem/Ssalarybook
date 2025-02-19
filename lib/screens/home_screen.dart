import 'dart:convert';

import 'package:beton_book/screens/Employees_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../login_page.dart';
import '../services/appResources.dart';
import '../services/app_provider.dart';
import 'package:http/http.dart' as http;
import '../services/scretResources.dart';
import 'tracking_page.dart';
import 'Logs_page.dart';

class HomeScreen extends StatefulWidget {
  final Employee employee;
  const HomeScreen({ required this.employee, super.key});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;
    int _currentIndex = context.watch<AppProvider>().index;
    final designation = employee.designation;

    final List<Widget> pages = [
      HomePage(employee:employee),
      TimeTracker(),
      LogsPage(),
      EmployeesPage()
    ];

    List<BottomNavigationBarItem> _navigationItems =  [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Track"),
    ];
    print(designation);
    if(designation==AppDesignations.admin){
      _navigationItems.add(BottomNavigationBarItem(icon: Icon(Icons.list), label: "Log"));
      _navigationItems.add(BottomNavigationBarItem(icon: Icon(Icons.group), label: "Employees"));
    }
    return WillPopScope(
        onWillPop: () async {
          final shouldAllowPop = _currentIndex == 1 ? true : false;
          setState(() {
            _currentIndex = 0;
          });
          return shouldAllowPop; // Block back navigation
        },
        child: Scaffold(
          appBar: _currentIndex==0?homeScreenAppBar(user: employee, action: [IconButton(
              onPressed: () async {
                // Handle sign out action
                await storage.delete(key: AppSecuredKey.token);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogInPage()));
              }, icon: Icon(Icons.logout))]): customAppBar(
              title:  (_currentIndex==2)?"Beton Book":"Beton Book",
              action: [ (_currentIndex==0)?
              IconButton(
                  onPressed: () async {
                    // Handle sign out action
                    await storage.delete(key: AppSecuredKey.token);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogInPage()));
                  }, icon: Icon(Icons.logout)): Text(""),
              ]),


          bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.mainColor,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white60,
                showSelectedLabels: true,


                currentIndex: _currentIndex,

                onTap: (index) {
                  context.read<AppProvider>().updateScannerState(scanningState: true);
                  setState(() {
                    context.read<AppProvider>().setIndex(index);
                  });

                },

                items: _navigationItems,
              )),
          body: pages[_currentIndex],
          drawer: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        color: AppColors.disabledMainColor,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50,),
                              Container(
                                  width: 80, // Diameter = 2 * radius
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.mainColor,
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/user.png"),
                                      fit: BoxFit.fitHeight, // Ensures the image fits properly
                                    ),
                                  )),
                              SizedBox(height: 15),
                              Text(employee.name,style: AppStyles.textH2,),
                              Text(employee.designation, style: AppStyles.textH3,),
                              SizedBox(height: 15),
                              Divider(
                                color: AppColors.accentColor,      // Color of the line
                                thickness: 4.0,          // Thickness of the line
                                indent: 0.0,            // Start padding
                                endIndent: 0.0,         // End padding
                              ),
                            ]
                        )),
                    Container( child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(onPressed: (){}, child: Text("Terms & Conditions", style: AppStyles.textH3,)),
                          TextButton(onPressed: (){}, child: Text("Contact Us",  style: AppStyles.textH3)),
                          TextButton(onPressed: (){}, child: Text("Help/FAQs",  style: AppStyles.textH3)),
                          TextButton(onPressed: (){}, child: Text("Subscriptions",  style: AppStyles.textH3)),
                          TextButton(onPressed: (){}, child: Text("Rate Us",  style: AppStyles.textH3)),
                          TextButton(onPressed: (){}, child: Text("Update",  style: AppStyles.textH3)),
                        ]
                    )),

                    Spacer(),


                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container( child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/ppclogotransparent.png',
                                width: 50, height: 50,fit: BoxFit.cover),
                            Text('Ptech ERP - Panacea Private Consultancy', style: AppStyles.bodyTextgray,),
                            Text('Version 1.2.1', style: AppStyles.bodyTextgray,),
                            Divider(
                              color: Colors.transparent,      // Color of the line
                              thickness: 0.0,          // Thickness of the line
                              indent: 0.0,            // Start padding
                              endIndent: 0.0,         // End padding
                            )
                          ],
                        ),
                        )
                    ),
                  ],
                )),
          ),
        ));
  }
}



class HomePage extends StatefulWidget {
  final Employee employee;
  const HomePage({ required this.employee, super.key});

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    List<Attendance> attendanceList = [];
    return Container(
        child: Center( child:  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10,),
        Text("Total Absent ", style: AppStyles.textH1,),
        Text("Total Late ", style: AppStyles.textH1,),
        IconButton(onPressed: (){setState(() {});}, icon: Icon(Icons.refresh)),
        SizedBox(height: 10,),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: fetchAttendances(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                print(attendanceList);
                attendanceList = snapshot.data!;
                return Container(
                      width: double.infinity,
                      child: DataTableTheme(
                    data: DataTableThemeData(
                      headingRowColor: MaterialStateProperty.all(
                          AppColors.disabledMainColor), // Change to desired color
                      headingTextStyle: AppStyles.textH2,
                    ),
                    child: DataTable(
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.white,
                            width: 2), // Set horizontal borders to white
                      ),
                      columnSpacing: 18,
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Entry')),
                        DataColumn(label: Text('Exit')),
                        // DataColumn(label: Text('Status')),
                      ],
                      rows: attendanceList
                          .map(
                            (record) =>
                            DataRow(
                              color: MaterialStateProperty.all(
                                  AppColors.disabledMainColor), // Sky blue background
                              cells: [
                                DataCell(Text(record.date)),
                                DataCell(Text(record.punchInTime)),
                                DataCell(Text(record.punchOutTime)),
                                // DataCell(Text(record.status)),
                              ],
                            ),
                      )
                          .toList(),
                    ),
                  ));
              } else {
                return Text("Something went Wrong");
              }
            }))]
      )));
  }

  Future<List<Attendance>?> fetchAttendances()async{
    final url = "${AppApis.attendenceLog}?employee=${widget.employee.id}";
    final response = await http.get(Uri.parse(url));
    print("${response.statusCode} ${response.body}");
    if(response.statusCode==200){
      List<Attendance> attendanceList = Attendance.fromJsonList(response.body);
        return  attendanceList;
    }
  }
}