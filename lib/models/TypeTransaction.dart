
class TypeTransaction {
  // Properties
  int? id;
  String? libelle;

  // Constructor
  TypeTransaction({
    required this.id,
    required this.libelle,
  });

  // Get categorie from Json data
  factory TypeTransaction.fromJson(Map<String, dynamic> json){
    return TypeTransaction(
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