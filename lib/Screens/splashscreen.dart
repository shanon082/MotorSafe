import 'package:flutter/material.dart';
import 'dart:async';

import 'package:motor_boda/Screens/getstartedpage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const GetStartedPage(),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1668797423269-4b29bd89066c?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Ym9kYSUyMHJpZGVyfGVufDB8fDB8fHww'), 
              fit: BoxFit.cover,
              opacity: 0.8
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Center(child: Text('MotorSafe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),)),
                ),
                const SizedBox(height: 20),
                CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}