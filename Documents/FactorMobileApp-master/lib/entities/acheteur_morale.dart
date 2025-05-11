import 'package:factor_mobile_app/entities/type_piece_identite.dart';

class AcheteurMorale {
  final String? raisonSocial;
  final String? numeroPieceIdentite;
  final TypePieceIdentite? typePieceIdentite;
  final String? adresse;

  AcheteurMorale({
    this.raisonSocial,
    this.numeroPieceIdentite,
    this.typePieceIdentite,
    this.adresse,
  });

  factory AcheteurMorale.fromJson(Map<String, dynamic> json) {
    return AcheteurMorale(
      raisonSocial: json['raisonSocial'],
      numeroPieceIdentite: json['numeroPieceIdentite'],
      adresse: json['adresse'],
      typePieceIdentite: json['typePieceIdentite'] != null
          ? TypePieceIdentite.fromJson(json['typePieceIdentite'])
          : null,
    );
  }
}
