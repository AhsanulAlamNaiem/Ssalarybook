import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:beton_book/services/appResources.dart';
import 'package:beton_book/services/app_provider.dart';
import 'package:beton_book/services/scretResources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'screens/home_screen.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email = "";
  String password = "";
  bool isLoading = false;
  final storage = FlutterSecureStorage();
  bool willSavePassword = true;


  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // This controls password visibility
  void showError(String message) {
    showDialog(
        context: context,
        builder: (contex) => AlertDialog(
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
                  bottomRight: Radius.circular(15), // Bottom right corner rounded
                ),
                child: AppBar(
                  backgroundColor: AppColors.mainColor,
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 26.0),
                        Text(" PPC salary Book", style: AppStyles.textOnMainColorheading,)
                      ]
                  ),
                  centerTitle: true,
                ))),
        body: SingleChildScrollView(child:  Padding(
            padding: const EdgeInsets.fromLTRB(16.0,40,16,0),
            child: Container(
                height: MediaQuery.of(context).size.height-165,
                child: Column( children: [ Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    AutofillGroup(
                        child: Column(
                            children: [
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
                              SizedBox(height: 20),
                              TextFormField(
                                // autofillHints: [AutofillHints.password],
                                obscureText: _obscurePassword,
                                // keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: IconButton(onPressed: (){
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });

                                  }, icon: Icon(_obscurePassword? Icons.visibility:Icons.visibility_off)),
                                  hintText: 'Password',
                                  border: OutlineInputBorder(),
                                  labelText: "Password",
                                ),
                                onChanged: (value) {
                                  password = value;
                                },
                              )])),
                    CheckboxListTile(
                        title: Text('Save Password!'),
                        value: willSavePassword,
                        onChanged: (bool? value) {
                          setState(() {
                            willSavePassword = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                        activeColor: AppColors.mainColor
                      // Checkbox position
                    ),
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                        style: AppStyles.elevatedButtonStyleFullWidth,
                        onPressed: () {
                          if(password=="" || email=="" ){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Email and Password should not be empty'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          login();
                        },
                        child: Text("Login", style: TextStyle(color: Colors.white),)),

                    // ElevatedButton(
                    //     style: AppStyles.elevatedButtonStyle,
                    //     onPressed: () async {
                    //       final value = await storage.read(key: securedKey);
                    //       print("$securedKey : $value");
                    //     },
                    //     child: Text("read Secure data"))

                  ],
                ),
                  Spacer(),
                  // Image.asset('assets/images/panaceaLogo.png',
                  //     width: 50, height: 50,fit: BoxFit.cover),
                  Divider(
                    color: AppColors.disabledMainColor,      // Color of the line
                    thickness: 4.0,          // Thickness of the line
                    indent: 60,            // Start padding
                    endIndent: 60.0,         // End padding
                  ),
                  Text("Employee Management- Panacea Private Consulting", style: TextStyle(color: AppColors.fontColorGray, fontSize:11)),
                  SizedBox(height: 10)])
            ))));
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(AppApis.login);
    final body = jsonEncode({"email": email, "password": password});
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data["data"]['token'];
      final employeeId = data["data"]['employee_id'];

      print(" succes: $employeeId $token");

      if (token != null) {
        final employeeUrl = "${AppApis.employeeDetails}$employeeId/";
        final response = await http.get(Uri.parse(employeeUrl));


        if (response.statusCode == 200) {
          Map<String, dynamic> employeeInfo = jsonDecode(response.body);
          User employee = User.buildFromJson(employeeInfo);

          final companyUrl = "${AppApis.company}${employee.company}/";
          final companyResponse = await http.get(Uri.parse(companyUrl));

          if (companyResponse.statusCode == 200) {
            final companyResponseJson = jsonDecode(companyResponse.body);
            final latitude = double.parse(companyResponseJson['latitude']);
            final longitude = double.parse(companyResponseJson['longitude']);

            // final double latitude = 24.9180;
            // final double longitude = 91.8376;

            employee.currentToken = token;
            employee.companyLatitude = latitude;
            employee.companyLongitude = longitude;

            if(willSavePassword)await storage.write(key: AppSecuredKey.userObject, value: jsonEncode(employee.toJson()));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AppProvider>().updateEmployee(newUser: employee);
            });


            // await FirebaseApi().initNotifications();

            showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text("Login Successful"),
                      content: Text("Welcome, ${employee.name}"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(
                                            user: User.buildFromJson(
                                                employeeInfo),
                                          )));
                            },
                            child: Text("Ok"))
                      ],
                    ));
          }
        } else {
          showError(
              'Failed Fetching User Info\n\n ${response.body} ${response.statusCode}');
          print(response.body);
        }
      } else {
        showError('Failed to Login');
      }
    } else {
      showError("${response.body}}");
    }
    setState(() {
      isLoading = false;
    });
  }
}
