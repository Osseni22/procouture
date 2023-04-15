class CategorieVetement {
  // Properties
  int? id;
  String? libelle;

  // Constructor
  CategorieVetement({
    required this.id,
    required this.libelle,
  });

  // Get categorie from Json data
  factory CategorieVetement.fromJson(Map<String, dynamic> json){
    return CategorieVetement(
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