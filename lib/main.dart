import 'package:flutter/material.dart';
import 'pages/activities_page.dart';

void main() {
  runApp(const MedicHealthApp());
}

class MedicHealthApp extends StatelessWidget {
  const MedicHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedicHealth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const ActivitiesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
