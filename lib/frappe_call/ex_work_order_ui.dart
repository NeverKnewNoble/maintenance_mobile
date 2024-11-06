import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'config.dart'; // Import your config file with baseUrl

// Initialize the logger
var logger = Logger();

// Model class for Ex Work Order
class ExWorkOrder {
  final String name;
  final String? date; // Make date nullable
  final String status;
  final String priorityLevel;

  ExWorkOrder({
    required this.name,
    this.date, // Nullable date field
    required this.status,
    required this.priorityLevel,
  });

  // Factory constructor to create an ExWorkOrder object from JSON data
  factory ExWorkOrder.fromJson(Map<String, dynamic> json) {
    return ExWorkOrder(
      name: json['name'],
      date: json['date'], // Accepts null
      status: json['status'],
      priorityLevel: json['priority_level'],
    );
  }
}

// Function to fetch all Ex Work Order documents
Future<List<ExWorkOrder>> fetchExWorkOrders() async {
  try {
    // Use baseUrl from config.dart
    var url = Uri.parse('$baseUrl/api/v2/method/ex_maintenance.api.orderview.ex_work_ui');

    // Send a GET request
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Log the response body for debugging
    logger.i('Response body: ${response.body}');

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response body
      var responseData = jsonDecode(response.body);

      // Access the inner "data" field that contains the list
      if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic> && responseData['data'].containsKey('data')) {
        List<dynamic> workOrderList = responseData['data']['data'];

        // Map the JSON data to a list of ExWorkOrder objects
        List<ExWorkOrder> exWorkOrders = workOrderList
            .map((item) => ExWorkOrder.fromJson(item))
            .toList();
        return exWorkOrders;
      } else {
        logger.e('Unexpected response format: Missing inner "data" field');
        throw Exception('Unexpected response format');
      }
    } else {
      logger.w('Failed to fetch data. Status code: ${response.statusCode}, Response body: ${response.body}');
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    logger.e('Error fetching Ex Work Order documents', error: e);
    rethrow; // Rethrow the error for handling at a higher level
  }
}
