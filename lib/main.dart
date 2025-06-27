// lib/main.dart
import 'package:flutter/material.dart';
import 'Screens/login_screen.dart';
import 'Screens/dashboard_screen.dart';
import 'Screens/inspection_form_screen.dart';

void main() {
  runApp(const SchoolInspectionApp());
}

class SchoolInspectionApp extends StatelessWidget {
  const SchoolInspectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Inspection App',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(name: '', role: '', token: '',),
        '/inspection': (context) => const InspectionFormScreen(token: '', name: '',),
      },
    );
  }
}
