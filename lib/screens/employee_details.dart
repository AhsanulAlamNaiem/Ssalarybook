import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beton_book/services/appResources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../services/scretResources.dart';


class EmployeeDetails extends StatefulWidget {
  final Employee employee;
  const EmployeeDetails({required this.employee, super.key});
  @override
  _EmployeeDetailsState createState() {
    return _EmployeeDetailsState();
  }
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  DateTime selectedDate = DateTime.now();
  List<Attendance>? lstAttendanceLog;
  List<Attendance> filteredAttendanceLog=[];

  @override
  void initState() {
    // TODO: implement initState
    _loadAttendance();
  }
  void _loadAttendance() async{
    final employee = widget.employee;
    final url = "${AppApis.attendanceLog}?employee=${employee.id}";
    print(url);
    final response = await http.get(Uri.parse(url));
    final attendanceJson = jsonDecode(response.body);
    print("${response.statusCode} ${response.body}");
    if(response.statusCode==200){
      List<Attendance> attendanceList =  attendanceJson.map((json){return Attendance.fromJson(json);}).toList().cast<Attendance>(); //Employee.buildFromJson(response.body);
      lstAttendanceLog = attendanceList;
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
    if(lstAttendanceLog!=null)filteredAttendanceLog = lstAttendanceLog!.where((att){
      return DateFormat('MMMM yyyy').format(selectedDate) == DateFormat('MMMM yyyy').format(att.date);
    }).toList();
    String formattedDate = DateFormat('MMMM yyyy').format(selectedDate);
    Employee employee = widget.employee;

    return Column( children: [
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
                    SizedBox(height: 20,)
                  ]
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(8,0,8,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 15,),
                Text("Total Absent: 1 day", style: AppStyles.textH2,),
                Text("Total Late: 1 day", style: AppStyles.textH2,),
                Text("Salary: 10,000 BDT", style: AppStyles.textH2,),
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
                (lstAttendanceLog==null) || (employee == null)? Center(child: CircularProgressIndicator()):
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
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Entry')),
                          DataColumn(label: Text('Exit')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: filteredAttendanceLog
                        !.map(
                              (record) => DataRow(
                            color: MaterialStateProperty.all(AppColors.disabledMainColor), // Sky blue background
                            cells: [
                              DataCell(Text(DateFormat("E,d MMM").format(record.date))),
                              DataCell(Text(record.punchInTime)),
                              DataCell(Text(record.punchOutTime)),
                              DataCell(Text(record.status=='Late'?record.status:"")),
                            ],
                          ),
                        )
                            .toList()
                    )
                )],
            ),
          )]);

  }
}
