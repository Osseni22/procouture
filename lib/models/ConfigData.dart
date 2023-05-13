/// Tva
class Tva {
  // Properties
  int? id;
  int? taux;

  // Constructor
  Tva({
    required this.id,
    required this.taux,
  });

  // Get categories from Json data
  factory Tva.fromJson(Map<String, dynamic> json){
    return Tva(
      id: json['id'],
      taux: json['taux'],
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'tva': taux,
    };
  }

}

/// Modes règlement
class ModeReglement {
  // Properties
  int? id;
  String? libelle;

  // Constructor
  ModeReglement({
    required this.id,
    required this.libelle,
  });

  // Get categorie from Json data
  factory ModeReglement.fromJson(Map<String, dynamic> json){
    return ModeReglement(
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