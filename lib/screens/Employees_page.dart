import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/appResources.dart';
import '../services/app_provider.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<User> lstEmployee =[];

  @override
  void initState() {

  }

  void _loadEmployees(){

  }

  void _refreash(){
    setState(() {

    });
  }
  void _navigateToDetailedEmployeePage(BuildContext context, User employee) {

  }

  @override
  Widget build(BuildContext context) {
    return lstEmployee.isEmpty
        ? Center(child: Text('No Employee Found'))
        : ListView.builder(
      itemCount: lstEmployee.length,
      itemBuilder: (context, index) {
        final employee = lstEmployee[index];
        return Card(
          child: ListTile(
            title: Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: Text(employee.name)),
                ]),
            onTap: () => _navigateToDetailedEmployeePage(context, employee),
          ),
        );
      },
    );
  }
}
