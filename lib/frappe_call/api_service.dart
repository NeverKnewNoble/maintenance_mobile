// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'config.dart';

// Future<Map<String, dynamic>> updateExWorkOrder(Map<String, dynamic> data) async {
//   final url = Uri.parse('$baseUrl/api/v2/method/ex_maintenance.api.orderview.update_and_assign_ex_work_order');

//   try {
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(data),
//     );

//     if (kDebugMode) {
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//     }

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       return {"status": "error", "message": "Failed to update Ex Work Order"};
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print("Error: $e");
//     }
//     return {"status": "error", "message": "Error: $e"};
//   }
// }




// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'config.dart';

// Future<void> updateAndAssignExWorkOrder({
//   required String docName,
//   required String priorityLevel,
//   required String status,
//   required int isATeam,
//   required String teamDescriptionInstructions,
//   required int isAnIndividual,
//   required String deadlineDate,
//   required String deadlineTime,
//   required List<Map<String, String>> assignTask,
// }) async {
//   // Define the URL for your API endpoint
//   const String url = "$baseUrl/api/v2/method/ex_maintenance.api.orderview.update_and_assign_ex_work_order";

//   // Prepare the data in the required format
//   final Map<String, dynamic> requestData = {
//     "data": {
//       "name": docName,
//       "priority_level": priorityLevel,
//       "status": status,
//       "is_a_team": isATeam,
//       "team_descriptioninstructions": teamDescriptionInstructions,
//       "is_an_individual": isAnIndividual,
//       "deadline_date": deadlineDate,
//       "deadline_time": deadlineTime,
//       "assign_task": assignTask,
//     }
//   };

//   try {
//     // Make the POST request
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(requestData),
//     );

//     // Check the response status
//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       if (responseData['status'] == 'success') {
//         if (kDebugMode) {
//           print("Ex Work Order updated successfully!");
//         }
//       } else {
//         if (kDebugMode) {
//           print("Error: ${responseData['message']}");
//         }
//       }
//     } else {
//       if (kDebugMode) {
//         print("Failed to update Ex Work Order. Status code: ${response.statusCode}");
//       }
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print("An error occurred: $e");
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> updateAndAssignExWorkOrder({
  required String docName,
  required String priorityLevel,
  required String status,
  required int isATeam,
  required String teamDescriptionInstructions,
  required int isAnIndividual,
  required String deadlineDate,
  required String deadlineTime,
  required List<Map<String, String>> assignTask,
}) async {
  const String url = "$baseUrl/api/v2/method/ex_maintenance.api.orderview.update_and_assign_ex_work_order";

  final Map<String, dynamic> requestData = {
    "data": {
      "name": docName,
      "priority_level": priorityLevel,
      "status": status,
      "is_a_team": isATeam,
      "team_descriptioninstructions": teamDescriptionInstructions,
      "is_an_indvidual": isAnIndividual,
      "deadline_date": deadlineDate,
      "deadline_time": deadlineTime,
      "assign_task": assignTask,
    }
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        if (kDebugMode) {
          print("Ex Work Order updated successfully!");
        }
        return {"status": "success", "message": responseData["message"] ?? "Updated successfully"};
      } else {
        if (kDebugMode) {
          print("Document: ${responseData['message']}");
        }
        return {"status": "success", "message": responseData["message"] ?? "Document Proccessed"};
      }
    } else {
      if (kDebugMode) {
        print("Failed to update Ex Work Order. Status code: ${response.statusCode}");
      }
      return {"status": "error", "message": "Failed to update Ex Work Order. Status code: ${response.statusCode}"};
    }
  } catch (e) {
    if (kDebugMode) {
      print("An error occurred: $e");
    }
    return {"status": "error", "message": "An error occurred: $e"};
  }
}
