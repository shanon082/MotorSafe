import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        backgroundColor: const Color(0xFF2563EB), 
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('contact page'),
      ),
    );
  }
}