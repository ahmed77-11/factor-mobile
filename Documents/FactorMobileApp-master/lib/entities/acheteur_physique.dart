import 'package:factor_mobile_app/entities/type_piece_identite.dart';

class AcheteurPhysique {
  final String? nom;
  final String? prenom;
  final String? numeroPieceIdentite;
  final TypePieceIdentite? typePieceIdentite;
  final String? adresse;

  AcheteurPhysique({
    this.nom,
    this.prenom,
    this.numeroPieceIdentite,
    this.typePieceIdentite,
    this.adresse,
  });

  factory AcheteurPhysique.fromJson(Map<String, dynamic> json) {
    return AcheteurPhysique(
      nom: json['nom'],
      prenom: json['prenom'],
      numeroPieceIdentite: json['numeroPieceIdentite'],
      adresse: json['adresse'],
      typePieceIdentite: json['typePieceIdentite'] != null
          ? TypePieceIdentite.fromJson(json['typePieceIdentite'])
          : null,
    );
  }
}
