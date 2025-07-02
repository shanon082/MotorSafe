import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFF2563EB), 
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('History page'),
      ),
    );
  }
}