class Avance {
  // Proprietes
  int? id;
  String? date;
  String? nom;
  int? montant;

  // Constructor
  Avance({
    required this.id,
    required this.date,
    required this.nom,
    required this.montant,
  });

  // Get instance form json
  factory Avance.fromJson(Map<String, dynamic> json) {
    return Avance(
      id: json['id'],
      date: json['date'],
      nom: json['nom'],
      montant: json['montant'],
    );
  }

}