class Employe {
  // Member Variables
  int? id;
  String? nom;
  String? adresse;
  String? ville;
  String? tel_mobile;
  String? tel_fixe;
  String? email;
  int? solde;
  int? atelier_id;

  // Constructor
  Employe({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.ville,
    required this.tel_mobile,
    required this.tel_fixe,
    required this.email,
    required this.solde,
    required this.atelier_id,
  });

  // Get instance data from a json data
  factory Employe.fromJson(Map<String, dynamic> json){
    return Employe(
        id: json['id'],
        nom: json['nom'],
        adresse: json['adresse'],
        ville: json['ville'],
        tel_mobile: json['tel_mobile'],
        tel_fixe: json['tel_fixe'],
        email: json['email'],
        solde: json['solde'],
        atelier_id: json['atelier_id']
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'ville': ville,
      'telephone1': tel_mobile,
      'telephone2': tel_fixe,
      'email': email,
      'acompte': solde,
      'atelier_id': atelier_id,
    };
  }
}