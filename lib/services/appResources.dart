import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppColors {
  static const Color mainColor = Color(0xFF6291FF);
  static const Color accentColor = Color(0x88EE1B22);
  static const Color fontColorBlack = Colors.black;
  static const Color fontColorGray = Color(0xFF5555555);
  static const Color disabledMainColor = Color(0xFFE8F3FF);
  static const Color textColorOnMainColor = Color(0xFFFFFFFF);

}

class AppFonts {
  static const Color mainColor = Color(0xFFDCDCDC);
  static const Color accentColor = Color(0xFF42A5F5);
  static const Color fontColorBlack = Colors.black;
  static const Color fontColorGray = Colors.grey;
  static const Color disabledMainColor = Color(0xFFBDBDBD);
}

class AppStyles {
  // Text Styles
  static const TextStyle textOnMainColorheading = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textColorOnMainColor,
  );

  static const TextStyle textH1 = TextStyle(
      fontSize: 18.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textH2 = TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textH2w = TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );

  static const TextStyle textH3 = TextStyle(
      fontSize: 14.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textH3w = TextStyle(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textH4 = TextStyle(
      fontSize: 12.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle bodyText = TextStyle(
      fontSize: 11.0,
      color: Colors.black,
      fontWeight: FontWeight.normal
  );

  static const TextStyle bodyTextgray = TextStyle(
      fontSize: 11.0,
      color: AppColors.fontColorGray,
      fontWeight: FontWeight.normal
  );

  static const TextStyle bodyTextBold = TextStyle(
      fontSize: 11.0,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textColorOnMainColor,
  );

  static ButtonStyle  textButtonWhite = TextButton.styleFrom(
      textStyle: textH4
  );

  // Button Styles
  static ButtonStyle elevatedButtonStyleFullWidth = ElevatedButton.styleFrom(
    backgroundColor: AppColors.mainColor,
    textStyle: buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ).copyWith(
    minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)), // Set minimum width to full screen width
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.mainColor,
    textStyle: buttonText,
  );


  static ButtonStyle homePageBUttonStyle = ElevatedButton.styleFrom(
    textStyle: buttonText,
    backgroundColor: Colors.white, // Button background color
    shadowColor: Colors.grey.withOpacity(0.4), // Light ash shadow
    elevation: 6, // Shadow elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ).copyWith(
    minimumSize: MaterialStateProperty.all(Size(double.infinity, 80)), // Set minimum width to full screen width
  );




  static  ButtonStyle textButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.all(0)),
  );

}



class AppDesignations{
  static const String admin = "Admin";
  static const String adminId = "3";
  static const String employee = "Employee";
}

class AppMachineStatus{
  static const String active = "active";
  static const String broken = "broken";
  static const String maintenance = "maintenance";
}

class AppWidgets{
  static Widget progressIndicator = ElevatedButton(
    style: AppStyles.elevatedButtonStyleFullWidth,
    onPressed: () {},
    child: SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );

  static Widget tableLoadingIndicator = Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Container( decoration: BoxDecoration(
          color: AppColors.mainColor,
          border: Border.all(color: Colors.black, width: 0),
          borderRadius: BorderRadius.circular(0),
        ),
          height: 30,
          width: double.infinity,),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mainColor, width: 1),
            borderRadius: BorderRadius.circular(0),
          ),
          width: double.infinity,
          height: 50,
          child: SizedBox( height: 25,width: 25, child:  Text("Fetching data ...")),
        ),
      ],
    ),
  );
}


PreferredSize customAppBar({required String title, List<Widget>? action = null , Widget? leading = null}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(50), // Adjust the height as needed
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), // Bottom left corner rounded
            bottomRight: Radius.circular(15), // Bottom right corner rounded
          ),
          child: AppBar(
            iconTheme: const IconThemeData(color:Colors.white),
            backgroundColor: AppColors.mainColor,
            title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(height: 20,),
                  Text(title, style: AppStyles.textOnMainColorheading,)
                ]
            ),
            centerTitle: true,
            leading: leading,
            actions: action,
          )));
}

PreferredSize homeScreenAppBar({required User user, List<Widget>? action = null , Widget? leading = null}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(260), // Adjust the height as needed
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), // Bottom left corner rounded
            bottomRight: Radius.circular(15), // Bottom right corner rounded
          ),
          child: Column( children: [AppBar(
            iconTheme: const IconThemeData(color:Colors.white),
            backgroundColor: AppColors.mainColor,
            centerTitle: true,
            leading: leading,
            actions: action,
          ),
            Container(
                height:200,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.mainColor),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: 130, // Diameter = 2 * radius
                          height: 130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/user.png"),
                              fit: BoxFit.fitHeight, // Ensures the image fits properly
                            ),)),
                      Text(user.name, style: AppStyles.textOnMainColorheading,),
                      Text(user.designation, style: AppStyles.textH3w,),
                      SizedBox(height: 20,)
                    ]
                ))
          ]
          )
      )
  );
}

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class Attendance {
  final int id;
  final int employee;
  final String punchInTime;
  final String punchOutTime;
  final String status;
  final DateTime date;

  Attendance({
    required this.id,
    required this.employee,
    required this.punchInTime,
    required this.punchOutTime,
    required this.status,
    required this.date,
  });

  // Factory method to create an Attendance object from JSON
  factory Attendance.fromJson(Map<dynamic, dynamic> json) {
    // print(json);
    // print("from model: ${json['id']}");

    DateTime timeIn = DateTime.parse(json['time_in']??'1990-01-01');
    DateTime timeOut = DateTime.parse(json['time_out']??'1990-01-01');
    DateTime date = DateTime.parse(json['date']);

    Attendance att = Attendance(
      id: json['id'],
      employee: json['employee'],
      punchInTime: DateFormat.Hm().format(timeIn),
      punchOutTime: DateFormat.Hm().format(timeOut),
      status: json['status'],
      date:  date,
    );
    return att;
  }

  static List<Attendance> fromJsonList(String jsonString){
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Attendance.fromJson(json)).toList();
  }
}

class Employee {
  final int id;
  final String name;
  String designation;
  String department;
  String company;
  final String phone;
  final String email;
  final String dateOfJoining;

  Employee({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.phone,
    required this.email,
    required this.company,
    required this.dateOfJoining,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      email: json["user"]['email'],
      name: "${json['first_name']} ${json['last_name']}",
      company: json["company"].toString(),
      department: json['department'].toString(),
      phone: json['mobile'].toString(),
      designation: json['designation'].toString(),
      dateOfJoining: json['date_of_joining'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final nameParts = name.split(' ');
    return {
      'id': id,
      'first_name': nameParts.first,
      'last_name': nameParts.length > 1 ? nameParts.last : "",
      'designation': designation,
      'department': department,
      'phone': phone,
      'user': {'email': email},
      'company': company,
      'date_of_joining': dateOfJoining,
    };
  }
}

class User extends Employee {

  List<Location> locations;
  List permissionGroups;

  User({
    required int id,
    required String name,
    required String designation,
    required String department,
    required String phone,
    required String email,
    required String company,
    required String dateOfJoining,
    required this.locations,
    required this.permissionGroups,
  }) : super(
    id: id,
    name: name,
    designation: designation,
    department: department,
    phone: phone,
    email: email,
    company: company,
    dateOfJoining: dateOfJoining,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    final locationsListOfObject = json["locations"]??[{"longitude":0.0000,"latitude":0.0000,"id":"Not a company location"}];
    final locationsListOfLocations = locationsListOfObject.map((json){
      print(json);
      return Location(longitude: json["longitude"], latitude: json["latitude"], branch_id: json["id"]);}).toList().cast<Location>();

    return User(
      id: json['id'],
      name: "${json['first_name']} ${json['last_name']}",
      designation: json['designation'].toString(),
      department: json['department'].toString(),
      phone: json['phone'].toString(),
      email: json["user"]['email'],
      company: json["company"].toString(),
      dateOfJoining: json['date_of_joining'] ?? "",
      locations:locationsListOfLocations,
      permissionGroups: json["group-name"]?? [],

    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['locations'] = locations.map((loc) => loc.toJson()).toList();
    json['group-name'] = permissionGroups;
    return json;
  }
}

class Location {
  final double longitude;
  final double latitude;
  final String branch_id;

  Location({required this.longitude, required this.latitude,required this.branch_id});

  factory Location.fromJson(Map<String, dynamic> json) {
    print(json["naiem"]);
    return Location(
      longitude: double.parse("${json['longitude']?? 0.0}"),
      latitude: double.parse("${json['latitude'] ?? 0.0}"),
      branch_id: json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'id': branch_id,
    };
  }
}


class AppUtility{
  static final context =  AppNavigator.navigatorKey.currentContext;
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