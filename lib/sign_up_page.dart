import 'package:beton_book/services/api_services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:beton_book/services/appResources.dart';
import 'package:beton_book/services/app_provider.dart';
import 'package:beton_book/services/scretResources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'screens/home_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "";
  String mobile = "";
  String password = "";
  String firstName = "";
  String lastName = "";
  String gender = "";
  String company = "";
  String department = "";
  String designation = "";
  String branch = "";
  String dateOfJoining = "";

  bool isLoading = false;
  final storage = FlutterSecureStorage();
  bool willSavePassword = true;
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  List? companiesData;
  List<String> companies= [];
  List<String> departments= [];
  List<String> designations= [];
  List<String> branches= [];


  @override
  void initState() {
    // TODO: implement initState

    _loadCompanies();


  }
  _loadCompanies() async {
    setState(() {
      isLoading = true;
    });
    final fetchedCompnayData = await ApiService().fetchCompaniesData();
    companiesData = fetchedCompnayData??[];
    final extractCompanies = companiesData!.map((company)=>company["name"]).toList().cast<String>();
    companies.addAll(extractCompanies);
    setState(() {
      isLoading = false;
    });
  }

  _selectionChnanges({required String selectedCompany}){
    print("selectedCompany: $selectedCompany");
    final selectedCompanyObject = companiesData!.firstWhere((company){
      final name = company["name"];
      print("name: $name ${name==selectedCompany}");
      return  name==selectedCompany;
    });
    print(selectedCompanyObject['name']);
    final extractDepartments = selectedCompanyObject["departments"].map((company)=>company["name"]).toList().cast<String>();
    final extractDesignations = selectedCompanyObject["designations"].map((company)=>company["title"]).toList().cast<String>();
    final extractbranches = selectedCompanyObject["branches"].map((company)=>company["name"]).toList().cast<String>();


    departments.addAll(extractDepartments);
    designations.addAll(extractDesignations);
    branches.addAll(extractbranches);
    setState(() {

    });
  }

  void showError(String message) {
    showDialog(
        context: context,
        builder: (contex) =>
            AlertDialog(
              title: Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("Ok"))
              ],
            ));
  }


  @override
  Widget build(BuildContext context) {
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
                      CustomTextField(label: "Firs Name", updater: (value)=> firstName = value),
                      CustomTextField(label: "Last Name", updater: (value)=> lastName = value),
                      CustomDropDown(label: "Gender", items: ["Male", "Female", "Third Gender"], updater: (value)=>gender = value),
                      CustomDropDown(label: "Company", items: companies, isLoading: isLoading , updater: (value){
                        company = value;
                      _selectionChnanges(selectedCompany: company);}),
                      CustomDropDown(label: "Department", items: departments, updater: (value)=>department = value),
                      CustomDropDown(label: "Designation", items: designations, updater: (value)=>designation = value),
                      CustomDropDown(label: "Branch", items: branches, updater: (value)=>branch = value),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Phone',
                          border: OutlineInputBorder(),
                          labelText: "Phone",
                        ),
                        onChanged: (value) {
                          mobile = value;
                        },
                      ),
                      TextFormField(
                        autofillHints: [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        // validator: (val)=> val!.isEmpty || !val.contains("@")?"enter a valid email":null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      TextFormField(
                        // autofillHints: [AutofillHints.password],
                        obscureText: _obscurePassword,
                        // keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),



                      isLoading
                          ? AppWidgets.progressIndicator
                          : ElevatedButton(
                          style: AppStyles.elevatedButtonStyleFullWidth,
                          onPressed: () {
                            if (password == "" ||
                                email == "" ||
                                firstName == "" ||
                                lastName == "" ||
                                gender == "" ||
                                company == "" ||
                                department == "" ||
                                designation == "" ||
                                branch == "" ||
                                mobile == ""
                            ) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'All fields Should be filled'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else{
                            sendSignUpRequest();
                            }
                          },
                          child: Text(
                            "Send Sign Up Request", style: TextStyle(color: Colors.white),)),

                      // ElevatedButton(
                      //     style: AppStyles.elevatedButtonStyle,
                      //     onPressed: () async {
                      //       final value = await storage.read(key: securedKey);
                      //       print("$securedKey : $value");
                      //     },
                      //     child: Text("read Secure data"))

                    ],
                  ),
                ))));
  }

  Future<void> sendSignUpRequest() async {
    setState(() {
      // isLoading = true;
    });
        print(password);
        print(email);
        print(firstName);
        print(lastName);
        print(gender);
        print(company);
        print(department);
        print(designation);
        print(branch);
        print(mobile);
        return;

    final isLoggedIn = await ApiService().tryLogIn(
        email: email, password: password);

    if (isLoggedIn) {
      final user = await ApiService().fetchUserInfoFunction();
      if (user != null) {
        final User userWithAllInfo = await ApiService().fetchUserPermissions(user: user);

        if(userWithAllInfo!= null) {
          storage.write(key: AppSecuredKey.userObject,
              value: jsonEncode(userWithAllInfo.toJson()));

          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text("Login Successful"),
                    content: Text("Welcome, ${userWithAllInfo.name}"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(
                                          user: userWithAllInfo,
                                        )));
                          },
                          child: Text("Ok"))
                    ],
                  ));
        } else{
          showError('Failed Fetching User Permissions');
        }
      } else {
        showError('Failed Fetching User Info');
      }
    } else {
      showError('Failed to Log In\n${ApiService.message}');
    }

    setState(() {
      isLoading = false;
    });
  }


}

class CustomTextField extends StatelessWidget{
  final String label;
  final Function updater;

  const CustomTextField({super.key, required this.label,required this.updater});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(),
          labelText: label,
        ),
        onChanged: (value) => updater(value)
    );
  }
}

class CustomDropDown extends StatefulWidget{
  String label;
  List<String> items;
  Function updater;
  bool isLoading;
  CustomDropDown({required this.label,required this.items,required this.updater,this.isLoading=false});

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<CustomDropDown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5), // Rounded corners
          border: Border.all(
              color: AppColors.fontColorGray, width: 1), // Border styling
        ),
        child: widget.items==[]? CircularProgressIndicator():
        DropdownButton<String>(
          value: selectedItem,
          // style: AppStyles.textH2,
          hint: widget.isLoading?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text("Select ${widget.label}"),
              SizedBox(height: 10,width: 10,child: CircularProgressIndicator(color: AppColors.fontColorGray,))],):
          Text("Select ${widget.label}"),
          items: widget.items.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = newValue;
              widget.updater(newValue);
            });
          },
        ));
  }
}