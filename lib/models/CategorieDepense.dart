
class CategorieDepense {
  // Properties
  int? id;
  String? libelle;

  // Constructor
  CategorieDepense({
    required this.id,
    required this.libelle,
  });

  // Get categorie from Json data
  factory CategorieDepense.fromJson(Map<String, dynamic> json){
    return CategorieDepense(
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