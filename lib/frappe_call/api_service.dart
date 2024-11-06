import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> updateExWorkOrder(Map<String, dynamic> data) async {
  final url = Uri.parse('$baseUrl/api/v2/method/ex_maintenance.api.orderview.update_and_assign_ex_work_order');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (kDebugMode) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"status": "error", "message": "Failed to update Ex Work Order"};
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    return {"status": "error", "message": "Error: $e"};
  }
}


// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'config.dart';

// class ApiService {
//   Future<Map<String, dynamic>> updateExWorkOrder(Map<String, dynamic> data) async {
//     final url = Uri.parse('$baseUrl/api/v2/method/ex_maintenance.api.orderview.update_and_assign_ex_work_order');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(data),
//       );

//       if (kDebugMode) {
//         print("Response status: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         return {"status": "error", "message": "Failed to update Ex Work Order"};
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error: $e");
//       }
//       return {"status": "error", "message": "Error: $e"};
//     }
//   }
// }
