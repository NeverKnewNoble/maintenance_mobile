import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'config.dart';

// Initialize the logger
var logger = Logger();

// Define a model class to represent the API response
class WorkOrderCount {
  final int openCount;
  final int completedCount;
  final String averageResponseTime;

  WorkOrderCount({
    required this.openCount,
    required this.completedCount,
    required this.averageResponseTime,
  });

  // Factory constructor to create a WorkOrderCount object from JSON data
  factory WorkOrderCount.fromJson(Map<String, dynamic> json) {
    return WorkOrderCount(
      openCount: json['open_count'],
      completedCount: json['completed_count'],
      averageResponseTime: json['average_response_time'],
    );
  }
}

// Function to fetch work order count data from the API
Future<WorkOrderCount> fetchWorkOrderCount() async {
  try {
    // Use baseUrl from config.dart
    var url = Uri.parse('$baseUrl/api/v2/method/ex_maintenance.api.card.get_work_order_count');

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

      // Check if the response contains the expected data structure
      if (responseData.containsKey('data')) {
        // Create a WorkOrderCount object from the JSON data
        return WorkOrderCount.fromJson(responseData['data']);
      } else {
        logger.e('Unexpected response format: Missing "data" field');
        throw Exception('Unexpected response format');
      }
    } else {
      logger.w('Failed to fetch data. Status code: ${response.statusCode}, Response body: ${response.body}');
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    logger.e('Error fetching work order count', error: e);
    rethrow; // Rethrow the error for handling at a higher level
  }
}
