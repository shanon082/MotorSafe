import 'package:flutter/material.dart';
import 'package:motor_boda/Screens/Contact/contact.dart';
import 'package:motor_boda/Screens/HomePage.dart';
import 'package:motor_boda/Screens/Myaccount/myaccount.dart';
import 'package:motor_boda/Screens/history.dart';
import 'package:motor_boda/Screens/location_page.dart';
import 'package:motor_boda/Screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:  Homepage()
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(),
        '/location': (context) => const LocationPage(),
        '/account': (context) => const Myaccount(),
        '/history': (context) => const History(),
        '/contact': (context) => const Contact(),
      }
      
      );
  }
}