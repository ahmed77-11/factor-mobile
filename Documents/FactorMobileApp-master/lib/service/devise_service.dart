import 'dart:convert';
import 'package:factor_mobile_app/entities/devise.dart';
import 'package:http/http.dart' as http;

class DeviseService {
  final String baseUrl = 'http://10.0.2.2:8083/factoring/contrat';

  Future<List<Devise>> fetchDevise(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/devise'),
        headers: {
          'Cookie': 'JWT_TOKEN=$token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Une erreur s'est produite");
      }

      final data = json.decode(response.body);
      final List<dynamic> rawDevises = data['_embedded']?['devises'] ?? [];

      final List<Devise> devises = rawDevises.map<Devise>((jsonDevise) {
        final selfLink = jsonDevise['_links']?['self']?['href'];
        final idString = selfLink != null ? selfLink.split('/').last : null;
        final id = int.tryParse(idString ?? '') ?? 0;

        return Devise(
          id: id,
          codeAlpha: jsonDevise['codeAlpha'],
          codeNum: jsonDevise['codeNum'],
          dsg: jsonDevise['dsg'],
        );
      }).toList();

      return devises;
    } catch (e) {
      print('Error fetching devises: $e');
      rethrow;
    }
  }
}
