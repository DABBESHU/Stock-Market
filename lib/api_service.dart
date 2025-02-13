import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      "https://illuminate-production.up.railway.app/api";

  // Login Function
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/local"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"identifier": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data["jwt"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("jwt", token);

      return token;
    }
    return null;
  }

  // Search Stocks
  Future<List<dynamic>> searchStocks(String query) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("jwt");

    final response = await http.get(
      Uri.parse("$baseUrl/stocks/search?query=$query"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }

  // Get Stock by ID
  Future<Map<String, dynamic>?> getStockById(int stockId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("jwt");

    final response = await http.get(
      Uri.parse("$baseUrl/stocks/$stockId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  // Get Stock Price Graph
  // Future<List<dynamic>> getStockGraph(int stockId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("jwt");

  //   final response = await http.get(
  //     Uri.parse("$baseUrl/stocks/$stockId/price-graph?range=1D"),
  //     headers: {"Authorization": "Bearer $token"},
  //   );

  //   return response.statusCode == 200 ? jsonDecode(response.body) : [];
  // }

  Future<List<dynamic>> getStockGraph(int stockId, String range) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("jwt");

    final response = await http.get(
      Uri.parse("$baseUrl/stocks/$stockId/price-graph?range=$range"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200 ? jsonDecode(response.body) : [];
  }
}
