import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beton_book/services/appResources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/scretResources.dart';
import 'employee_details_page.dart';


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

    final responseEmp = await http.get(Uri.parse(AppApis.employeeDetails));
    final responseJsonEmp = jsonDecode(responseEmp.body);
    print(responseJsonEmp);

    if(response.statusCode==200) {
      lstEmployee = responseJsonEmp.map((json){print(json); return Employee.buildFromJson(json);}).toList().cast<Employee>();
    }
    if(response.statusCode==200){
      List<Attendance> attendanceList =  attendanceJson.map((json){return Attendance.fromJson(json);}).toList().cast<Attendance>(); //Employee.buildFromJson(response.body);
      setState(() {
        lstAttendanceLog = attendanceList;
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
        // filteredAttendanceLog = lstAttendanceLog;
        filteredAttendanceLog = lstAttendanceLog.where((attendence){
          print("Selected Date:${selectedDate}");
          print("Employee Date: ${attendence.date}");
          return selectedDate==attendence.date;}).toList();
        print(filteredAttendanceLog);
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
    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd MMMM').format(selectedDate);
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
                          formattedDate,
                          style: AppStyles.textH2w
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: () => _selectDate(context), // Open date picker
                      ),
                    ],
                  ))),
          SizedBox(height: 20),
          // Table for employee details
          DataTableTheme(
              data: DataTableThemeData(
                headingRowColor: MaterialStateProperty.all(AppColors.disabledMainColor), // Change to desired color
                headingTextStyle: AppStyles.textH2,
              ),
              child: DataTable(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.white, width: 2), // Set horizontal borders to white
                ),
                columnSpacing: 18,
                columns: [
                  DataColumn(label: Text('Emp')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Entry')),
                  DataColumn(label: Text('Exit')),
                  DataColumn(label: Text('Status')),
                ],
                rows: filteredAttendanceLog
                    .map(
                      (record) => DataRow(
                    color: MaterialStateProperty.all(AppColors.disabledMainColor), // Sky blue background
                    cells: [
                      DataCell(Text("${record.employee}"),onDoubleTap:()=>_navigateToDetailedEmployeePage(context, record.employee)),
                      DataCell(Text(DateFormat("E, d MMM").format(record.date)),onDoubleTap:()=> _navigateToDetailedEmployeePage(context, record.employee)),
                      DataCell(Text(record.punchInTime),onDoubleTap:()=> _navigateToDetailedEmployeePage(context, record.employee)),
                      DataCell(Text(record.punchOutTime),onDoubleTap:()=> _navigateToDetailedEmployeePage(context, record.employee)),
                      DataCell(Text(record.status=='Late'?record.status:""),onDoubleTap:()=> _navigateToDetailedEmployeePage(context, record.employee)),
                    ]
                  ),
                )
                    .toList()
              )
          )],
      ),
    );

  }
}
