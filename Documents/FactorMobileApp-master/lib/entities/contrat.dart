class Contrat {
  final int id;
  final String contratNo;
  // Add other properties from your Java Contrat entity

  Contrat({
    required this.id,
    required this.contratNo,
    // Initialize other properties here
  });

  factory Contrat.fromJson(Map<String, dynamic> json) {
    return Contrat(id: json['id'], contratNo: json['contratNo']
        // Map other fields from JSON
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contratNo': contratNo
      // Include other fields matching your Java Contrat entity
    };
  }
}
