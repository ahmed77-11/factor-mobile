class NotificationUser {
  final int id;
  final String titre;
  final String message;
  final DateTime date;
  final bool lu;

  NotificationUser({
    required this.id,
    required this.titre,
    required this.message,
    required this.date,
    this.lu = false,
  });

  factory NotificationUser.fromJson(Map<String, dynamic> json) {
    return NotificationUser(
      id: json['id'],
      titre: json['titre'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      lu: json['lu'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'message': message,
      'date': date.toIso8601String(),
      'lu': lu,
    };
  }
}
