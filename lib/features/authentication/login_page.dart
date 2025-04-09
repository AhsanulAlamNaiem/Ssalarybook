import 'package:beton_book/core/domain/response.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:beton_book/core/presentation/app_styles.dart';
import 'package:beton_book/core/presentation/widgets/app_utility.dart';
import 'package:beton_book/core/presentation/widgets/app_widgets.dart';
import 'package:beton_book/core/theme/app_colors.dart';
import 'package:beton_book/features/authentication/api_services.dart';
import 'package:beton_book/features/authentication/provider.dart';
import 'package:beton_book/features/authentication/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../core/presentation/home_screen.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email = "";
  String password = "";
  final storage = FlutterSecureStorage();
  bool willSavePassword = true;

  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // This controls password visibility


  @override
  Widget build(BuildContext context) {
    AuthenticationProvider provider = context
        .watch<AuthenticationProvider>();
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
                        Text("PPC salary Book",
                          style: AppStyles.textOnMainColorheading,)
                      ]
                  ),
                  centerTitle: true,
                ))),
        body: SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 40, 16, 0),
            child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 165,
                child: Column(children: [ Column(
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
                              )
                            ])),
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
                    provider.isLoading
                        ? AppWidgets.progressIndicator
                        : ElevatedButton(
                        style: AppStyles.elevatedButtonStyleFullWidth,
                        onPressed: () async{
                          if (password == "" || email == "") {
                            AppUtility.showToast(FunctionResponse(
                                success: false,
                                message: "Email and Password can not be empty."));
                            return;
                          }
                          provider.setLoadingState(true);
                            await loginFunction().catchError(() {});
                          provider.setLoadingState(false);
                        },
                        child: Text( "Login", style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => SignUpPage())),
                        child: Text("Send Sign Up request?"))

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
                    color: AppColors.disabledMainColor, // Color of the line
                    thickness: 4.0, // Thickness of the line
                    indent: 60, // Start padding
                    endIndent: 60.0, // End padding
                  ),
                  Text("Employee Management- Panacea Private Consulting",
                      style: TextStyle(
                          color: AppColors.fontColorGray, fontSize: 11)),
                  SizedBox(height: 10)])
            ))));
  }

  Future<void> loginFunction() async {
    final loginResponse = await ApiService().login(
        email: email, password: password);
    if(!loginResponse.success) {
      showError(loginResponse.message);
    }else{
      final user = context
          .read<AppProvider>()
          .user;

      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                  title: Text("Login Successful"),
                  content: Text("Welcome, ${user.name}"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen()));
                        },
                        child: Text("Ok"))
                  ]
              ),
          barrierDismissible: false
      );
    }
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
}
