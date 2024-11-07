import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ex_maintenance/frappe_call/config.dart';

Future<List<String>> fetchUserEmails() async {
  final url = Uri.parse('$baseUrl/api/method/your_app.your_module.api.get_user_emails');
  
  // Make the GET request
  final response = await http.get(url);

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Parse the JSON response
    final data = json.decode(response.body);
    
    // Extract the email list
    List<String> emails = List<String>.from(data['data']);
    return emails;
  } else {
    // Handle error response
    throw Exception('Failed to load emails');
  }
}
