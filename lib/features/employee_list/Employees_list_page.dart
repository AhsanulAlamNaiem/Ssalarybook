import 'dart:convert';
import 'package:beton_book/core/domain/employee.dart';
import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/appResources.dart';
import '../../core/presentation/app_provider.dart';
import '../../core/constants/scretResources.dart';
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
    final employees = await http.get(Uri.parse(AppApis.employeeDetails));
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

        emp.company = company['name'];
        emp.designation = designation['title'];

        return emp;
      }).toList().cast<Employee>();


      setState(() {
        lstEmployee = mergedList;
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
        return Container( margin: EdgeInsets.fromLTRB(10,2,2,10), child: Card(
          child: ListTile(
            title:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(employee.id.toString() + ") " + employee.name, style: AppStyles.textH2,),
                  Text(employee.company, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.mainColor)),
                  Text(employee.designation, style: AppStyles.textH3),
                  SizedBox(height: 8,),
                  Container(

                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("phone: ${employee.phone}",style: TextStyle(fontSize: 13, color: AppColors.fontColorGray) ),
                      IconButton(onPressed: () async{
                        final Uri url = Uri.parse("tel:${employee.phone}");
                        if(await launchUrl(url)){
                        } else{
                          print("not a phone number");
                        }
                      }, icon: Icon(Icons.phone, color: AppColors.fontColorGray, size: 18,))],)),
                  Container(

                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("mail: ${employee.email}", style: TextStyle(fontSize: 13, color: AppColors.fontColorGray)),
                      IconButton(onPressed: () async{
                        final url = Uri( scheme: 'mailto', path:employee.email);
                        if(await launchUrl(url)){
                        }else{
                          print("not email");
                        }},
                          icon: Icon(Icons.mail, color: AppColors.fontColorGray, size: 18))],)),
                ]),
            onTap: () => _navigateToDetailedEmployeePage(context, employee),
          ),
        ));
      },
    );
  }
}
