import 'dart:async';
import 'dart:convert';

import 'package:factor_mobile_app/entities/acheteur_response.dart';
import 'package:http/http.dart' as http;

class RelationsService {
  static const String baseUrl = "http://10.0.2.2:8081/factoring/api/relations";

  Future<List<AcheteurResponse>> fetchAcheteurs(int id, String token) async {
    print('$baseUrl/acheteurs/$id');
    final response = await http.get(
      Uri.parse(
        '$baseUrl/acheteurs/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'JWT_TOKEN=$token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => AcheteurResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load acheteurs');
    }
  }
}
