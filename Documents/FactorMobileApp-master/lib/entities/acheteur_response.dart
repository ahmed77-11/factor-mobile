import 'package:factor_mobile_app/entities/acheteur_morale.dart';
import 'package:factor_mobile_app/entities/acheteur_physique.dart';

class AcheteurResponse {
  final int id;
  final AcheteurPhysique? acheteurPhysique;
  final AcheteurMorale? acheteurMorale;
  final String? delaiMaxPai;
  final String? limiteAchat;
  final String? resteAchat;
  final String? limiteCouverture;
  final String? comiteRisqueTexte;
  final String? comiteDerogTexte;
  final String? effetDate;
  final String? infoLibre;

  AcheteurResponse({
    required this.id,
    this.acheteurPhysique,
    this.acheteurMorale,
    this.delaiMaxPai,
    this.limiteAchat,
    this.resteAchat,
    this.limiteCouverture,
    this.comiteRisqueTexte,
    this.comiteDerogTexte,
    this.effetDate,
    this.infoLibre,
  });

  factory AcheteurResponse.fromJson(Map<String, dynamic> json) {
    return AcheteurResponse(
      id: json['id'],
      acheteurPhysique: json['acheteurPhysique'] != null
          ? AcheteurPhysique.fromJson(json['acheteurPhysique'])
          : null,
      acheteurMorale: json['acheteurMorale'] != null
          ? AcheteurMorale.fromJson(json['acheteurMorale'])
          : null,
      delaiMaxPai: json['delaiMaxPai']?.toString(),
      limiteAchat: json['limiteAchat']?.toString(),
      resteAchat: json['resteAchat']?.toString(),
      limiteCouverture: json['limiteCouverture']?.toString(),
      comiteRisqueTexte: json['comiteRisqueTexte'],
      comiteDerogTexte: json['comiteDerogTexte'],
      effetDate: json['effetDate'],
      infoLibre: json['infoLibre'],
    );
  }
}
