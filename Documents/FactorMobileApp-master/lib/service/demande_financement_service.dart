import 'dart:convert';
import 'dart:math';

import '../entities/DemandeFinancement.dart';
import 'package:http/http.dart' as http;

class DemandeFinancementService {
  final String baseUrl =
      'http://10.0.2.2:8083/factoring/contrat/api/demfin'; // 10.0.2.2 pour l'émulateur Android

  Future<bool> envoyerDemande(DemandeFinancement demande, String token) async {
    print(demande.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/add-demfin'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'JWT_TOKEN=$token'
      },
      body: jsonEncode(demande.toJson()), // Correctly serializes nested Contrat
    );
    return response.statusCode == 200;
  }

  Future<List<DemandeFinancement>> fetchDemandes() async {
    final response = await http
        .get(Uri.parse('$baseUrl/all')); // À adapter selon ton endpoint

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => DemandeFinancement.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des demandes');
    }
  }

  Future<List<DemandeFinancement>> fetchAllDemandes(
    int id,
    String token,
  ) async {
    print('$id  $token');
    final response = await http.get(
      Uri.parse('$baseUrl/all-demfins-encours-by-contrat/$id'),
      headers: {
        "Cookie": 'JWT_TOKEN=$token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DemandeFinancement.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des demandes');
    }
  }

  Future<void> deleteDemande(int id, String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete-demfin/$id'),
        headers: {'Cookie': 'JWT_TOKEN=$token'});

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression de la demande');
    }
  }

  Future<void> updateDemande(
    DemandeFinancement demande,
    token,
  ) async {
    final url = Uri.parse('$baseUrl/update-demfin');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'JWT_TOKEN=$token',
      },
      body: jsonEncode(demande.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Échec de la mise à jour de la demande (code: ${response.statusCode})');
    }
  }
}
