
import 'dart:convert';

import 'package:beton_book/services/appResources.dart';
import 'package:beton_book/services/app_provider.dart';
import 'package:beton_book/services/scretResources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Initialize Firebase
  // await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context)=>AppProvider()
          )
      ],
    child: MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SPlashScreenState createState() {
    return _SPlashScreenState();
  }
}

class _SPlashScreenState extends State<SplashScreen> {
  final storage = FlutterSecureStorage();
  String? designation;

  @override
  void initState() {
    // TODO: implement initState
    _loginControl();
  }

  Future<void> _loginControl() async {
    Future.delayed(Duration(seconds: 5), () {
      print("wait 5 second");
    });
    print("doing next");

    final strUser = await storage.read(key: AppSecuredKey.userObject);

    print("token $strUser");
    if (strUser != null) {
      User user = User.buildFromJson(jsonDecode(strUser));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppProvider>().updateEmployee(newUser: user);
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(
          user: user
      )));
    } else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Center(child:Column(
          children: [
            CircularProgressIndicator()
          ],
        ),)
    );
  }
}
