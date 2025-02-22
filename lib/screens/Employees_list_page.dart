import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/appResources.dart';
import '../services/app_provider.dart';
import '../services/scretResources.dart';
import 'package:http/http.dart' as http;

import 'employee_details_page.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Employee> lstEmployee =[];
  bool isLoading = true;

  @override
  void initState() {
    _loadEmployees();
  }

  void _loadEmployees() async{
    final response = await http.get(Uri.parse(AppApis.employeeDetails));
    final employeeJson = jsonDecode(response.body);
    print("${response.statusCode} ${response.body}");
    if(response.statusCode==200){
      List<Employee> employeeList =  employeeJson.map((json){return Employee.buildFromJson(json);}).toList().cast<Employee>(); //Employee.buildFromJson(response.body);
      setState(() {
        lstEmployee = employeeList;
      });
    }
  }

  void _refreash(){
    setState(() {
    });
  }

  void _navigateToDetailedEmployeePage(BuildContext context, Employee employee) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeDetailsPage(employee:employee)));
  }

  @override
  Widget build(BuildContext context) {
    return lstEmployee.isEmpty
        ? Center( child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: lstEmployee.length,
      itemBuilder: (context, index) {
        final employee = lstEmployee[index];
        return Card(
          child: ListTile(
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(employee.id.toString() + " " + employee.name, style: AppStyles.textH2,),
                  Text(employee.company, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.mainColor)),
                  Text(employee.designation, style: AppStyles.textH3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("phone: ${employee.phone}",style: TextStyle(fontSize: 13, color: AppColors.fontColorGray) ),
                      IconButton(onPressed: () async{
                        final Uri url = Uri.parse("tel:${employee.phone}");
                        if(await launchUrl(url)){
                        } else{
                          print("not a phone number");
                        }
                      }, icon: Icon(Icons.phone, color: AppColors.fontColorGray, size: 20,))],),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("mail: ${employee.email}", style: TextStyle(fontSize: 13, color: AppColors.fontColorGray)),
                      IconButton(onPressed: () async{
                        final url = Uri( scheme: 'mailto', path:employee.email);
                        if(await launchUrl(url)){
                        }else{
                          print("not email");
                        }},
                          icon: Icon(Icons.mail, color: AppColors.fontColorGray, size: 20))],),
                ]),
            onTap: () => _navigateToDetailedEmployeePage(context, employee),
          ),
        );
      },
    );
  }
}
