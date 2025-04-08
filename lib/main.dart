import 'package:beton_book/core/navigation/global_app_navigator.dart';
import 'package:beton_book/core/presentation/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'core/Local_Data_Manager/CachedDataService.dart';
import 'features/authentication/login_page.dart';
import 'features/authentication/provider.dart';
import 'features/punchInOut/provider.dart';
import 'core/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_US', null);
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
          ChangeNotifierProvider(create: (context)=>AppProvider()),
          ChangeNotifierProvider(create: (context)=>PunchingProvider()),
          ChangeNotifierProvider(create: (context)=>AuthenticationProvider()),
      ],
    child: MaterialApp(
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Add other locales if needed
      ],
      navigatorKey: GlobalNavigator.navigatorKey,
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
    _loginControl();
  }

  Future<void> _loginControl() async {
    final bool isLoggedIn = await CachedDataService.isLoggedIn();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> isLoggedIn? HomeScreen():LogInPage()));
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
