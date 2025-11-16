import 'package:flutter/material.dart';

void main() {
  runApp(const KingdomOfAbacusApp());
}

/// Main application widget
class KingdomOfAbacusApp extends StatelessWidget {
  const KingdomOfAbacusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kingdom of Abacus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Kingdom of Abacus - Coming Soon!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
