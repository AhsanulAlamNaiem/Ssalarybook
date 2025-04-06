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

import '../employee_list/employee_details_page.dart';

class SignupRequestsPage extends StatefulWidget {
  @override
  _SignupRequestsPageState createState() => _SignupRequestsPageState();
}

class _SignupRequestsPageState extends State<SignupRequestsPage> {
  List<Employee> lstRequests =[];
  bool isLoading = true;

  @override
  void initState() {
    _loadRequests();
  }

  void _loadRequests() async{
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
        lstRequests = mergedList;
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
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color:Colors.white),
          backgroundColor: AppColors.mainColor,
          title: Text("Sign Up Requests", style: AppStyles.textH2w,),
          centerTitle: true,
          // actions: [
          //   IconButton(onPressed: () async {setState(() {});}, icon: Icon(Icons.refresh)),
          // ],
        ),
        body: lstRequests.isEmpty
            ? Center( child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: lstRequests.length,
          itemBuilder: (context, index) {
            final requestedEmployee = lstRequests[index];
            return Container( margin: EdgeInsets.fromLTRB(10,2,2,10),
              child: GestureDetector(
                child: ApprovalCard(
                    id: requestedEmployee.id,
                    name: requestedEmployee.name,
                    department: requestedEmployee.department,
                    designation: requestedEmployee.designation,
                    email: requestedEmployee.email,
                    phone: requestedEmployee.phone),
                onTap: () {},
              ),
            );
          },
        ));
  }
}


class ApprovalCard extends StatelessWidget {
  final int id;
  final String name;
  final String designation;
  final String department;
  final String email;
  final String phone;

  const ApprovalCard({
    Key? key,
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(designation, style: const TextStyle(color: Colors.grey)),
                    Text(department, style: const TextStyle(color: Colors.grey)),
                    Text("Phone $phone", style: const TextStyle(color: Colors.grey)),
                    Text("Email: $email", style: const TextStyle(color: Colors.grey)),
                  ])),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(8.0)),
                    ),
                  ).copyWith(
                    minimumSize: MaterialStateProperty.all(Size((MediaQuery.of(context).size.width-20) / 2, 40)), // Set minimum width to full screen width
                  ),
                  child: const Text('Approve',style: AppStyles.textH2w),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomRight:  Radius.circular(8.0)),
                    ),
                  ).copyWith(
                    minimumSize: MaterialStateProperty.all(Size((MediaQuery.of(context).size.width-20) / 2, 40)), // Set minimum width to full screen width
                  ),
                  child: const Text('Reject',style: AppStyles.textH2w,),
                )])
        ],
      ),
    );
  }
}
