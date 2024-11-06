import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> getAllExWorkOrders() async {
    final url = Uri.parse('$baseUrl/api/v2/method/ex_maintenance.api.orderview.get_all_ex_work_orders');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        // Handle non-200 responses
        return {"error": "Failed to load data, status code: ${response.statusCode}"};
      }
    } catch (e) {
      // Handle errors
      return {"error": "An error occurred: $e"};
    }
  }
}
