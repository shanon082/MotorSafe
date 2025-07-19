import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:motor_boda/Screens/Contact/contact.dart';
import 'package:motor_boda/Screens/HomePage.dart';
import 'package:motor_boda/Screens/Myaccount/my_account_page.dart';
import 'package:motor_boda/Screens/history.dart';
import 'package:motor_boda/Screens/location_page.dart';
import 'package:motor_boda/Screens/rider/rider_homepage.dart';
// import 'package:motor_boda/Screens/auth_screens.dart';
import 'package:motor_boda/Screens/getstartedpage.dart';
import 'package:motor_boda/Screens/successpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motor Boda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const GetStartedPage(),
        '/home': (context) {
          // In a real app, you would check user type from your auth state
          final isRider =
              ModalRoute.of(context)!.settings.arguments as bool? ?? false;
          return isRider ? const RiderHomepage() : const Homepage();
        },
        '/location': (context) => const LocationPage(),
        '/account': (context) => const MyAccountPage(),
        '/history': (context) => HistoryPage(),
        '/contact': (context) => const ContactPage(),
        '/success': (context) => const Successpage(),
      },
    );
  }
}
