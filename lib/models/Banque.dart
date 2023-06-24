class Banque {
  // Properties
  int? id;
  String? libelle;
  int? solde;
  //String? solde;

  // Constructor
  Banque({
    required this.id,
    required this.libelle,
    required this.solde,
  });

  // Get categorie from Json data
  factory Banque.fromJson(Map<String, dynamic> json){
    return Banque(
      id: json['id'],
      libelle: json['libelle'],
      solde: json['solde'],
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'libelle': libelle,
      'solde': solde,
    };
  }

}

class BanqueU {
  // Properties
  int? id;
  String? libelle;
  //int? solde;
  String? solde;

  // Constructor
  BanqueU({
    required this.id,
    required this.libelle,
    required this.solde,
  });

  // Get categorie from Json data
  factory BanqueU.fromJson(Map<String, dynamic> json){
    return BanqueU(
      id: json['id'],
      libelle: json['libelle'],
      solde: json['solde'],
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'libelle': libelle,
      'solde': solde,
    };
  }

}