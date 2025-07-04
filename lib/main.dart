import 'package:flutter/material.dart';
import 'package:motor_boda/Screens/Contact/contact.dart';
import 'package:motor_boda/Screens/HomePage.dart';
import 'package:motor_boda/Screens/Myaccount/my_account_page.dart';
import 'package:motor_boda/Screens/history.dart';
import 'package:motor_boda/Screens/location_page.dart';
// import 'package:motor_boda/Screens/splashscreen.dart';
// import 'package:motor_boda/Screens/splashscreen.dart';

void main() {
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
      // home:  Splashscreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(),
        '/location': (context) => const LocationPage(),
        '/account': (context) => const MyAccountPage(),
        '/history': (context) => HistoryPage(),
        '/contact': (context) => const ContactPage(),
      }
      
      );
  }
}