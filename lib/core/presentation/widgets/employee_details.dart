import 'dart:convert';
import 'package:beton_book/core/domain/attendance.dart';
import 'package:beton_book/core/domain/employee.dart';
import 'package:beton_book/core/network_manager/api_end_points.dart';
import 'package:beton_book/core/network_manager/dio_client.dart';
import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/presentation/widgets/app_widgets.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import '../../Local_Data_Manager/cacheKeys.dart';
import '../app_provider.dart';


class EmployeeDetails extends StatefulWidget {
  final Employee employee;
  const EmployeeDetails({required this.employee, super.key});
  @override
  EmployeeDetailsState createState() {
    return EmployeeDetailsState();
  }
}

class EmployeeDetailsState extends State<EmployeeDetails> {
  DateTime selectedDate = DateTime.now();
  List<Attendance>? lstAttendanceLog;
  List<Attendance> filteredAttendanceLog=[];
  bool isLoading = false;
  DioClient dioClient = DioClient();

  @override
  void initState() {
    if(widget.employee.id == context.read<AppProvider>().user.id){
      if(context.read<AppProvider>().currentUsersAttendanceLog.isNotEmpty){
        lstAttendanceLog = context.read<AppProvider>().currentUsersAttendanceLog;
      } else{
        _loadAttendance();
      }
    }
  }

  Future _refresh() async{
    final employee = widget.employee;
    final url = "${ApiEndPoints.attendanceLog}?employee=${employee.id}";
    final response = await dioClient.get(url);
    if(response.data["success"]){
      final attendanceJson = response.data["data"];
      List<Attendance> attendanceList =  attendanceJson.map((json){return Attendance.fromJson(json);}).toList().cast<Attendance>(); //Employee.buildFromJson(response.body);
      lstAttendanceLog = attendanceList;
      if(widget.employee.id == context.read<AppProvider>().user.id){
        context.read<AppProvider>().updateCurrentUsersAttendance(attendanceList);
      }
      print(lstAttendanceLog!.length);
      print("attendencelog");
    }else{
      lstAttendanceLog = [];
    }
  }

  Future<void> _refressh() async {
    await Future.delayed(Duration(seconds: 10)); // simulate network delay
    setState(() {
      print("false");
    });
  }



  void _loadAttendance() async{
    setState(() {
      isLoading = true;
    });

    final employee = widget.employee;
    final url = "${ApiEndPoints.attendanceLog}?employee=${employee.id}";
    final response = await dioClient.get(url);
    if(response.data["success"]){
    final attendanceJson = response.data["data"];
      List<Attendance> attendanceList =  attendanceJson.map((json){return Attendance.fromJson(json);}).toList().cast<Attendance>(); //Employee.buildFromJson(response.body);
      lstAttendanceLog = attendanceList;
      if(widget.employee.id == context.read<AppProvider>().user.id){
        context.read<AppProvider>().updateCurrentUsersAttendance(attendanceList);
      }
      print(lstAttendanceLog!.length);
      print("attendencelog");
    }else{
      lstAttendanceLog = [];
    }
    setState(() {
    });
  }

  Future<void> _selectMonth(BuildContext context) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if(lstAttendanceLog!=null){filteredAttendanceLog = lstAttendanceLog!.where((att){
      return DateFormat('MMMM yyyy').format(selectedDate) == DateFormat('MMMM yyyy').format(att.date);
    }).toList();}
    filteredAttendanceLog.sort((a,b)=>b.date.compareTo(a.date));
    print(filteredAttendanceLog.length);
    String formattedDate = DateFormat('MMMM yyyy').format(selectedDate);
    Employee employee = widget.employee;
    final lateDays =  filteredAttendanceLog.where((att){return att.status=="Late";}).toList();

    return RefreshIndicator(
      onRefresh: _refresh,
       child: SingleChildScrollView( child:  Column( children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),),
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
                    Text(employee.name, style: AppStyles.textOnMainColorheading,),
                    Text(employee.designation, style: AppStyles.textH3w,),
                    Text(employee.company, style: AppStyles.textH3w,),
                    SizedBox(height: 20,)
                  ]
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,0,8,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 15,),
                // Text("Total Absent: 1 day", style: AppStyles.textH2,),
                Text("Total Late: ${lateDays.length} days", style: AppStyles.textH2,),
                Text("Salary: *,***.** BDT", style: AppStyles.textH2,),
                SizedBox(height: 15,),
                // Display the selected date
                Card(
                    color: AppColors.mainColor,
                    elevation: 0,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                formattedDate,
                                style: AppStyles.textH2w
                            ),
                            IconButton(
                              icon: Icon(Icons.calendar_today, color: Colors.white),
                              onPressed: () => _selectMonth(context), // Open date picker
                            ),
                          ],
                        ))),
                SizedBox(height: 0),
                // Table for employee details
                (lstAttendanceLog==null) || (employee == null)? AppWidgets.tableLoadingIndicator() :
                Container(

                  child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(0.38 * screenWidth), // Date column width
                    1: FixedColumnWidth(0.27 * screenWidth), // Entry column width
                    2: FixedColumnWidth(0.27 * screenWidth), // Exit column width
                  },
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.white, width: 2), // Horizontal borders white
                    verticalInside: BorderSide(color: Colors.white, width: 2),   // Vertical borders white
                    top: BorderSide(color: Colors.white, width: 2),               // Top border
                    bottom: BorderSide(color: Colors.white, width: 2),            // Bottom border
                  ),
                  children: [
                    // Table Header
                    TableRow(
                      decoration: BoxDecoration(
                        color: AppColors.mainColor, // Header row color
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Date',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Entry',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Exit',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    // Table Rows
                    for (var record in filteredAttendanceLog)
                      TableRow(
                        decoration: BoxDecoration(
                          color: record.status == 'Late' ? Colors.red.shade100 : Colors.transparent, // Status background color
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(DateFormat("E, d MMM").format(record.date),textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(record.punchInTime,textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(record.punchOutTime,textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                  ],
                ))],
            ),
          )])));

  }
}
