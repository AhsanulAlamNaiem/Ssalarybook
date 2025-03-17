import 'package:beton_book/screens/Employees_list_page.dart';
import 'package:beton_book/screens/signup_requests_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../login_page.dart';
import '../services/appResources.dart';
import '../services/scretResources.dart';
import 'Logs_page.dart';
import 'employee_details.dart';
import 'employee_details_page.dart';
import 'tracking_page.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({ required this.user, super.key});

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  int _currentIndex = 0;

  final GlobalKey<EmployeeDetailsState> page1Key = GlobalKey();


  void _refreshPage() {
    page1Key.currentState?.refresh();  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    user.permissionGroups.add("Admin");
    final designation = user.designation;

    final List<Widget> pages = [
      EmployeeDetails(employee:  user),
      TimeTracker(),
      LogsPage(),
      EmployeesPage()
    ];

    List<BottomNavigationBarItem> _navigationItems =  [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Track"),
    ];
    print(designation);
    if(user.permissionGroups.contains("Admin")){
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

          appBar: _currentIndex==0? AppBar(
            iconTheme: const IconThemeData(color:Colors.white),
            backgroundColor: AppColors.mainColor,
            title: Text(""),
            centerTitle: true,
            // actions: [
            //   IconButton(onPressed: () async {setState(() {});}, icon: Icon(Icons.refresh)),
            // ],
          ): customAppBar(
              title:  (_currentIndex==2)?"Beton Book":"Beton Book",
          ),

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
                  print(index);
                  setState(() {
                    _currentIndex = index;
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
                              Text(user.name,style: AppStyles.textH2,),
                              Text(user.designation, style: AppStyles.textH3,),
                              Text(user.company, style: AppStyles.textH3,),
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
                          TextButton(onPressed: (){}, child: Text("Remote Employees", style: AppStyles.textH2,)),
                          user.permissionGroups.contains("Admin")?TextButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupRequestsPage()));
                          }, child: Text("Sign Up Requests", style: AppStyles.textH2,)):SizedBox(height: 0,),
                          TextButton(onPressed: (){}, child: Text("Subscriptions",  style: AppStyles.textH3)),
                          TextButton(onPressed: (){}, child: Text("Contact Us",  style: AppStyles.textH3)),
                          TextButton(onPressed: (){}, child: Text("Terms & Conditions", style: AppStyles.textH3,)),
                          TextButton(
                              onPressed: () async {
                                // Handle sign out action
                                await storage.delete(key: AppSecuredKey.userObject);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LogInPage()));
                              }, child: Row( children: [Text("Log Out ", style: AppStyles.textH3,),Icon(Icons.logout)]))
                        ]
                    )),

                    Spacer(),


                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container( child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Image.asset('assets/images/ppclogotransparent.png',
                            //     width: 50, height: 50,fit: BoxFit.cover),
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