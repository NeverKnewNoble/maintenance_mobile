import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'config.dart'; // Import the config file

// Initialize the logger
var logger = Logger();

// Model class for Ex Request (only includes "name" and "creation" fields)
class ExRequest {
  final String name;
  final DateTime creation;

  ExRequest({
    required this.name,
    required this.creation,
  });

  // Factory constructor to create an ExRequest object from JSON data
  factory ExRequest.fromJson(Map<String, dynamic> json) {
    return ExRequest(
      name: json['name'],
      creation: DateTime.parse(json['creation']),
    );
  }
}

// Function to fetch all Ex Request documents
Future<List<ExRequest>> fetchExRequests() async {
  try {
    // Use baseUrl from config.dart
    var url = Uri.parse('$baseUrl/api/v2/method/ex_maintenance.api.request.get_all_ex_requests');

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

      // Check if the response contains the expected "data" field
      if (responseData.containsKey('data') && responseData['data'].containsKey('data')) {
        // Map the JSON data to a list of ExRequest objects
        List<ExRequest> exRequests = (responseData['data']['data'] as List)
            .map((item) => ExRequest.fromJson(item))
            .toList();
        return exRequests;
      } else {
        logger.e('Unexpected response format: Missing "data" field');
        throw Exception('Unexpected response format');
      }
    } else {
      logger.w('Failed to fetch data. Status code: ${response.statusCode}, Response body: ${response.body}');
      throw Exception('Failed to fetch data');
    }
  } catch (e) {
    logger.e('Error fetching Ex Request documents', error: e);
    rethrow; // Rethrow the error for handling at a higher level
  }
}
