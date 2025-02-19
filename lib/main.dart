
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
  Future<Employee?> loginControl() async {
    // final name =  "John Doe";
    // final designation = "admin";
    // final department = "Engineering";
    // final company = "Acme Corporation";

    // await storage.write(key: securedKey, value: "252534563456");
    // await storage.write(key: securedName, value: name);
    // await storage.write(key: securedDesignation, value: designation);
    // await storage.write(key: securedDepartment, value: department);
    // await storage.write(key: securedCompany, value: company);

    final token = await storage.read(key: AppSecuredKey.token);
    final name = await storage.read(key: AppSecuredKey.name);
    designation = await storage.read(key: AppSecuredKey.designation);
    final department = await storage.read(key: AppSecuredKey.department);
    final company = await storage.read(key: AppSecuredKey.company) ;
    final id = await storage.read(key: AppSecuredKey.id);
    final List<Attendance> att=[];

    print("token $token");
    if (token != null) {
      final user = Employee(
          id:int.parse(id!),
          name: name!,
          designation: designation!,
          department: department!,
          phone: company!,
          email: "a@b.c",
          company: ""
      );

      return user;
    }
    return null;



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: FutureBuilder(
          future: loginControl(),
          builder: (context, snapshot) {
            Future(() {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Column( children: [CircularProgressIndicator()]));
              } else if (snapshot.hasData) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(
                    employee: snapshot.data!
                )));
                // login();
              } else {
                print(snapshot.data);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LogInPage()));
              }
            });
            return Center(
                child: Column(
              children: [CircularProgressIndicator()],
            ));
          },
        ));
  }
}
