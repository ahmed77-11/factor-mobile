import 'package:factor_mobile_app/entities/contrat.dart';
import 'package:factor_mobile_app/entities/devise.dart';

class DemandeFinancement {
  final int id;
  final String numeroContrat;
  final String adherEmisNo;
  final String adherEmisDate;
  final String adherRib;
  final double adherMontant;
  final Devise devise;
  final String adherLibelle;
  final String adherInfoLibre;
  final Contrat contrat;

  DemandeFinancement({
    required this.id,
    required this.numeroContrat,
    required this.adherEmisNo,
    required this.adherEmisDate,
    required this.adherRib,
    required this.adherMontant,
    required this.devise,
    required this.adherLibelle,
    required this.adherInfoLibre,
    required this.contrat,
  });

  factory DemandeFinancement.fromJson(Map<String, dynamic> json) {
    return DemandeFinancement(
      id: json['id'] ?? 0,
      numeroContrat: json['numeroContrat'] ?? '',
      adherEmisNo: json['adherEmisNo'] ?? '',
      adherEmisDate: json['adherEmisDate'] ?? '',
      adherRib: json['adherRib'] ?? '',
      adherMontant: (json['adherMontant'] as num?)?.toDouble() ?? 0.0,
      devise: Devise.fromJson(json['devise'] ?? {}),
      adherLibelle: json['adherLibelle'] ?? '',
      adherInfoLibre: json['adherInfoLibre'] ?? '',
      contrat: Contrat.fromJson(json['contrat'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroContrat': numeroContrat,
      'adherEmisNo': adherEmisNo,
      'adherEmisDate': adherEmisDate,
      'adherRib': adherRib,
      'adherMontant': adherMontant,
      'devise': devise.toJson(),
      'adherLibelle': adherLibelle,
      'adherInfoLibre': adherInfoLibre,
      'contrat': contrat.toJson(),
    };
  }
}
