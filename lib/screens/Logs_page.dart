import 'package:beton_book/services/appResources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class LogsPage extends StatefulWidget {
  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {

  final List<Map<String, dynamic>> jsonData = [
    {"id": 1, "date":"1 - feb", "punch_in_time": "08:00 AM", "punch_out_time": "05:00 PM", "distance": 10.5},
    {"id": 2, "date":"2 - feb", "punch_in_time": "09:15 AM", "punch_out_time": "06:30 PM", "distance": 8.2},
    {"id": 3, "date":"3 - feb", "punch_in_time": "07:45 AM", "punch_out_time": "04:50 PM", "distance": 12.0},
  ];



  DateTime selectedDate = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd MMMM').format(selectedDate);
    List<Attendance> attendanceList = jsonData.map((json) => Attendance.fromJson(json)).toList();

    return Padding(
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
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('Entry')),
                  DataColumn(label: Text('Exit')),
                  DataColumn(label: Text('Distance')),
                ],
                rows: attendanceList
                    .map(
                      (record) => DataRow(
                    color: MaterialStateProperty.all(AppColors.disabledMainColor), // Sky blue background
                    cells: [
                      DataCell(Text(record.date)),
                      DataCell(Text(record.punchInTime)),
                      DataCell(Text(record.punchOutTime)),
                      DataCell(Text(record.status)),
                    ],
                  ),
                )
                    .toList(),
              )
          )],
      ),
    );

  }
}
