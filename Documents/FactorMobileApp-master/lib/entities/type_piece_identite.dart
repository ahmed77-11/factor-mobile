class TypePieceIdentite {
  final String? dsg;

  TypePieceIdentite({this.dsg});

  factory TypePieceIdentite.fromJson(Map<String, dynamic> json) {
    return TypePieceIdentite(dsg: json['dsg']);
  }
}
