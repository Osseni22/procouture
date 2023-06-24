class Employe{
  // Member Variables
  int? id;
  String? ref;
  String? nom;
  String? adresse;
  String? ville;
  String? telephone;
  String? email;
  int? salaire;
  int? comission;
  int? avance_salaire;
  int? active;
  int? poste_id;
  int? atelier_id;

  // Constructor
  Employe({
    required this.id,
    required this.ref,
    required this.nom,
    required this.adresse,
    required this.ville,
    required this.telephone,
    required this.salaire,
    required this.email,
    required this.comission,
    required this.avance_salaire,
    required this.active,
    required this.poste_id,
    required this.atelier_id,
  });

  // Get instance data from a json data
  factory Employe.fromJson(Map<String, dynamic> json){
    return Employe(
        id: json['id'],
        ref: json['ref'],
        nom: json['nom'],
        adresse: json['adresse'],
        ville: json['ville'],
        telephone: json['telephone'],
        salaire: json['salaire'],
        email: json['email'],
        comission: json['comission'],
        avance_salaire: json['avance_salaire'],
        active: json['active'],
        poste_id: json['poste_id'],
        atelier_id: json['atelier_id']
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'ref': ref,
      'nom': nom,
      'adresse': adresse,
      'ville': ville,
      'telephone': telephone,
      'salaire': salaire,
      'email': email,
      'comission': comission,
      'atelier_id': atelier_id,
      'poste_id': poste_id,
      'active': active,
      'avance_salaire': avance_salaire,
    };
  }
}