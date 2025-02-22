import 'package:beton_book/services/appResources.dart';
import 'package:flutter/material.dart';
import 'employee_details.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;
  const EmployeeDetailsPage({required this.employee, super.key});
  @override
  _EmployeeDetailsPageState createState() {
    return _EmployeeDetailsPageState();
  }
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {


  @override
  Widget build(BuildContext context) {
    final employee = widget.employee;
        return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color:Colors.white),
          backgroundColor: AppColors.mainColor,
          title: Text(""),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () async {setState(() {});}, icon: Icon(Icons.refresh)),
          ],
        ),
        body: EmployeeDetails(employee: employee,));

  }
}
