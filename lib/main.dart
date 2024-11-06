import 'package:ex_maintenance/main/home.dart';
// import 'package:ex_maintenance/main/work_order_details.dart';
import 'package:flutter/material.dart';
// import 'package:ex_maintenance/intro_pages/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ex-Maintenance',
      home: HomePage()
      // home: WorkOrderDetails(workOrderData: {},),
    );
  }
}
