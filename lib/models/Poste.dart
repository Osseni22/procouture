class Poste {
  // Properties
  int? id;
  String? libelle;

  // Constructor
  Poste({
    required this.id,
    required this.libelle,
  });

  // Get categorie from Json data
  factory Poste.fromJson(Map<String, dynamic> json){
    return Poste(
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