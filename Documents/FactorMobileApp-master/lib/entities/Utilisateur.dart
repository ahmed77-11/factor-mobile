class Utilisateur {
  final int id;
  final String email;
  final String rne;
  final String firstName;
  final String lastName;
  final List<String> roles;
  final String token;
  final bool forceChangePassword;
  final String? profilePicture;
  final double limiteAuto;
  final double disponible;
  final double utilise;
  final int adherentId;
  final int contratId;

  Utilisateur({
    required this.id,
    required this.email,
    required this.rne,
    required this.firstName,
    required this.lastName,
    required this.roles,
    required this.token,
    required this.forceChangePassword,
    this.profilePicture,
    required this.limiteAuto,
    required this.disponible,
    required this.utilise,
    required this.adherentId,
    required this.contratId,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      email: json['email'],
      rne: json['rne'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      roles: List<String>.from(json['roles']),
      token: json['token'],
      forceChangePassword: json['forceChangePassword'],
      profilePicture: json['profilePicture'],
      limiteAuto: (json['limiteAuto'] as num).toDouble(),
      disponible: (json['disponible'] as num).toDouble(),
      utilise: (json['utilise'] as num).toDouble(),
      adherentId: json['adherentId'],
      contratId: json['contratId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'rne': rne,
      'firstName': firstName,
      'lastName': lastName,
      'roles': roles,
      'token': token,
      'forceChangePassword': forceChangePassword,
      'profilePicture': profilePicture,
      'limiteAuto': limiteAuto,
      'disponible': disponible,
      'utilise': utilise,
      'adherentId': adherentId,
      'contratId': contratId,
    };
  }
}
