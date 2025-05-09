import 'dart:convert';
import 'package:beton_book/core/domain/attendance.dart';
import 'package:beton_book/core/domain/employee.dart';
import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:beton_book/core/constants/appResources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/Local_Data_Manager/cacheKeys.dart';
import '../employee_list/employee_details_page.dart';


class LogsPage extends StatefulWidget {
  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {

  final List<Map<String, dynamic>> jsonData = [];
  List<Attendance> lstAttendanceLog = [];
  List<Attendance> filteredAttendanceLog = [];
  List<Employee> lstEmployee = [];
  DateTime selectedDate = DateTime.now();


  void _loadAttendance() async{
    final response = await http.get(Uri.parse(AppApis.attendanceLog));
    final attendanceJson = jsonDecode(response.body);
    print("All Attendence ${attendanceJson}");
    if(response.statusCode==200){
      List<Attendance> attendanceList =  attendanceJson.map((json){return Attendance.fromJson(json);}).toList().cast<Attendance>(); //Employee.buildFromJson(response.body);
        lstAttendanceLog = attendanceList;
      setState(() {
      });
    }
  }

  void _loadEmployees() async{
    final employees = await http.get(Uri.parse(AppApis.employeeList));
    final companies = await http.get(Uri.parse(AppApis.company));
    final designations = await http.get(Uri.parse(AppApis.designations));

    final employeeJson = jsonDecode(employees.body);
    final companiesJson = jsonDecode(companies.body);
    final designationsJson = jsonDecode(designations.body);

    print("${employees.statusCode} ${employees.body}");
    if(employees.statusCode==200){
      List<Employee> employeeList =  employeeJson.map((json){return Employee.fromJson(json);}).toList().cast<Employee>(); //Employee.buildFromJson(response.body);

      var mergedList = employeeList.map((emp) {
        var company = companiesJson.firstWhere((comp) => comp['id'].toString() == emp.company.toString(), orElse: () => emp.company);
        var designation = designationsJson.firstWhere((desg) => desg['id'].toString() == emp.designation.toString(), orElse: () => emp.designation);

        print("${emp.company}: $company");

        // emp.company = company['name'];
        // emp.designation = designation['title'];

        return emp;
      }).toList().cast<Employee>();

      setState(() {
        lstEmployee = mergedList;
      });
    }
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: selectedDate.add(Duration(days: 365)),
    ) ?? selectedDate;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
      });
    }
  }

  void _navigateToDetailedEmployeePage(BuildContext context, int employeeId) {
    Employee employee = lstEmployee.firstWhere((emp){return emp.id == employeeId;});
    Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeDetailsPage(employee:employee)));
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadEmployees();
    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String formattedSelectedDate = DateFormat('EEEE, dd MMMM').format(selectedDate);
    filteredAttendanceLog = lstAttendanceLog.where((attendence){
      print("Selected Date:${selectedDate}");
      print("Employee Date: ${attendence.date}");
      return formattedSelectedDate== DateFormat('EEEE, dd MMMM').format(attendence.date);}).toList();
    return lstAttendanceLog.isEmpty? Center(child: CircularProgressIndicator()) : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                          formattedSelectedDate,
                          style: AppStyles.textH2w
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: () => _selectDate(context), // Open date picker
                      ),
                    ],
                  ))),
          SizedBox(height: 20),
          SingleChildScrollView( child: Table(
            columnWidths: {
              0: FixedColumnWidth(0.43 * screenWidth), // Date column width
              // 1: FixedColumnWidth(0.29 * screenWidth), // Entry column width
              1: FixedColumnWidth(0.165 * screenWidth), // Exit column width
              2: FixedColumnWidth(0.165 * screenWidth),  // Status column width// Status column width
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
                      'Emp',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Text(
                  //     'Date',
                  //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                  //   ),
                  // ),
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
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Status',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                    ),
                  ),
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
                      padding: EdgeInsets.all(0),
                      child: TextButton(onPressed: ()=>_navigateToDetailedEmployeePage(context, record.employee), style:TextButton.styleFrom(
                        alignment: Alignment.centerLeft, // Align text to the left
                      ), child: Text(
                        lstEmployee.firstWhere((emp) => emp.id == record.employee).name,style: TextStyle(fontSize: 11, color: Colors.black),
                      )),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(0),
                    //   child: TextButton(onPressed: ()=>_navigateToDetailedEmployeePage(context, record.employee), child: Text(
                    //     DateFormat("E, d MMM").format(record.date),textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black),
                    //   )),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: TextButton(onPressed: ()=>_navigateToDetailedEmployeePage(context, record.employee), child: Text(record.punchInTime,textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black),)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: TextButton(onPressed: ()=>_navigateToDetailedEmployeePage(context, record.employee), child: Text(record.punchOutTime,textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black),)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: TextButton(onPressed: ()=>_navigateToDetailedEmployeePage(context, record.employee), child: Text(record.status == 'Late' ? record.status : "",textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black),)),
                    ),
                  ],
                ),
            ],
          ))],
      ),
    );

  }
}
