import 'package:flutter/material.dart';
import 'package:motor_boda/Screens/HomePage.dart';

class Successpage extends StatelessWidget {
  const Successpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 90,),
            SizedBox(height: 10,),
            Text('Account Created Successfully', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(value: false, onChanged: (value) => true,),
                Text('I agree to the terms and condition', style: TextStyle(color: Colors.white),)
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                  );
                },
                child: const Text(
                  'Contunie',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}