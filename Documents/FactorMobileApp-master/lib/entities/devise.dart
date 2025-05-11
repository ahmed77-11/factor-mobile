class Devise {
  final int id;
  final String codeNum;
  final String codeAlpha;
  final String dsg;

  Devise({
    required this.id,
    required this.codeAlpha,
    required this.codeNum,
    required this.dsg,
  });

  factory Devise.fromJson(Map<String, dynamic> json) {
    return Devise(
      id: json['id'],
      codeAlpha: json['codeNum'],
      codeNum: json['codeAlpha'],
      dsg: json['dsg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codeNum': codeNum,
      'codeAlpha': codeAlpha,
      'dsg': dsg,
    };
  }
}
