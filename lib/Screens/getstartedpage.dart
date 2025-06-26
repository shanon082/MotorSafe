import 'package:flutter/material.dart';
import 'package:motor_boda/Screens/HomePage.dart';

class Getstartedpage extends StatelessWidget {
  const Getstartedpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1668797423269-4b29bd89066c?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Ym9kYSUyMHJpZGVyfGVufDB8fDB8fHww'), // Replace with your image URL
                    fit: BoxFit.cover,                    
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Explore the World of Motor Boda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (context) => const HomePage()),
               );
              },
              child: const Text('Get Started...', style: TextStyle(fontSize: 18, color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}