import 'package:beton_book/core/presentation/widgets/app_utility.dart';
import 'package:beton_book/features/authentication/api_services.dart';
import 'package:beton_book/core/domain/user.dart';
import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/presentation/widgets/app_widgets.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:beton_book/features/signup_request_management/NewUser.dart';
import 'package:beton_book/features/signup_request_management/clouddata.dart';
import 'package:beton_book/features/signup_request_management/provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:beton_book/core/constants/appResources.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/core/Local_Data_Manager/cacheKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/presentation/home_screen.dart';
import '../../core/presentation/widgets/custom_drop_down.dart';
import '../../core/presentation/widgets/custom_textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  NewUser newUser= NewUser();
  List<String> companies= [];
  List<String> departments= [];
  List<String> designations= [];
  List<String> branches= [];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)=>_loadCompanies());
  }

  _loadCompanies() async {
    final companyDataResponse = await CloudOperations.fetchCompaniesData();
    if(!companyDataResponse.success){

    }
  }

  _selectionChanges({required String selectedCompany}){
    print("selectedCompany: $selectedCompany");
    final companiesData = context.watch<SignUpProvider>().companies;
    final selectedCompanyObject = companiesData.firstWhere((company){
      final name = company["name"];
      print("name: $name ${name==selectedCompany}");
      return  name==selectedCompany;
    });
    print(selectedCompanyObject['name']);
    final extractDepartments = selectedCompanyObject["departments"].map((department)=>department["name"]).toList().cast<String>();
    final extractDesignations = selectedCompanyObject["designations"].map((designation)=>designation["title"]).toList().cast<String>();
    final extractbranches = selectedCompanyObject["branches"].map((branch)=>branch["name"]).toList().cast<String>();

    departments.addAll(extractDepartments);
    designations.addAll(extractDesignations);
    branches.addAll(extractbranches);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider provider = context.watch<SignUpProvider>();
    companies = provider.companies.map((company)=>company["name"]).toList().cast<String>();
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80), // Adjust the height as needed
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15), // Bottom left corner rounded
                  bottomRight: Radius.circular(
                      15), // Bottom right corner rounded
                ),
                child: AppBar(
                  backgroundColor: AppColors.mainColor,
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 26.0),
                        Text(" PPC salary Book",
                          style: AppStyles.textOnMainColorheading,)
                      ]
                  ),
                  centerTitle: true,
                ))),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 20, 16, 0),
                child: Container(
                  height: 72*10, //MediaQuery.of(context).size.height - 165,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomTextField(label: "Firs Name", updater: (value)=> newUser.firstName = value),
                      CustomTextField(label: "Last Name", updater: (value)=> newUser.lastName = value),
                      CustomDropDown(label: "Gender", items: ["Male", "Female", "Third Gender"], updater: (value)=>newUser.gender = value),
                      CustomDropDown(label: "Company", items: companies, isLoading: provider.isLoading ,
                          updater: (value){
                            newUser.company = value;
                            _selectionChanges(selectedCompany: value);
                          }
                      ),
                      CustomDropDown(label: "Department", items: departments, updater: (value)=>newUser.department = value),
                      CustomDropDown(label: "Designation", items: designations, updater: (value)=>newUser.designation = value),
                      CustomDropDown(label: "Branch", items: branches, updater: (value)=>newUser.branch = value),
                      CustomTextField(label: "Phone", updater: (value)=> newUser.mobile = value, icon: Icon(Icons.phone),),
                      CustomTextField(label: "Email", updater: (value)=> newUser.email = value, icon: Icon(Icons.email),),
                      PassWordTextField(updater: (value)=>newUser.email = value),

                      provider.isLoading
                          ? AppWidgets.progressIndicator
                          : ElevatedButton(
                          style: AppStyles.elevatedButtonStyleFullWidth,
                          onPressed: () {
                            final completion = newUser.isComplete();
                            if(!completion.success){
                              AppUtility.showToast(completion, color:Colors.red.shade500);
                            } else{
                              CloudOperations.sendSignUpRequest(newUser);
                            }
                          },
                          child: Text(
                            "Send Sign Up Request", style: TextStyle(color: Colors.white),)),
                    ],
                  ),
                ))));
  }

}
