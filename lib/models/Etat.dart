class Etat {
  // Properties
  int? id;
  String? libelle;

  // Constructor
  Etat({
    required this.id,
    required this.libelle,
  });

  // Get categorie from Json data
  factory Etat.fromJson(Map<String, dynamic> json){
    return Etat(
      id: json['id'],
      libelle: json['libelle'],
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'libelle': libelle,
    };
  }
}