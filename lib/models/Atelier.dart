class Atelier {
  // Member Variables
  late int? id;
  late String? identifiant;
  late String? libelle;
  late String? tel_mobile;
  late String? tel_fixe;
  late String? email;
  late int? solde;
  late String? logo;
  late int? monnaie_id;
  late int? compte_id;
  late int? pays_id;
  late Monnaie? monnaie;
  late Pays? pays;

  // Constructor
  Atelier({
    required this.id,
    required this.identifiant,
    required this.libelle,
    required this.tel_mobile,
    required this.tel_fixe,
    required this.email,
    required this.solde,
    required this.logo,
    required this.monnaie_id,
    required this.compte_id,
    required this.pays_id,
    this.monnaie,
    this.pays,
  });

  // Get instance data from a json data
  factory Atelier.fromJson(Map<String, dynamic> json){
    return Atelier(
      id: json['id'],
      identifiant: json['identifiant'],
      libelle: json['libelle'],
      tel_mobile: json['tel_mobile'],
      tel_fixe: json['tel_fixe'],
      email: json['email'],
      solde: json['solde'],
      logo: json['logo'],
      monnaie_id: json['monnaie_id'],
      compte_id: json['compte_id'],
      pays_id: json['pays_id'],
      monnaie: json['monnaie'] != null ? Monnaie.fromJson(json['monnaie'] as Map<String, dynamic>) : null,
      pays: json['pays'] != null ? Pays.fromJson(json['pays'] as Map<String, dynamic>) : null,
    );
  }

  // Convert to Json
  Map<String, String> toJson() {
    return {
      'id': id.toString(),
      'identifiant': identifiant.toString(),
      'libelle': libelle.toString(),
      'tel_mobile': tel_mobile.toString(),
      'tel_fixe': tel_fixe.toString(),
      'email': email.toString(),
      'solde': solde.toString(),
      'logo': logo.toString(),
      'monnaie_id': monnaie_id.toString(),
      'compte_id': compte_id.toString(),
      'pays_id': pays_id.toString(),
      'monnaie': monnaie?.toJson() as String,
      'pays': pays?.toJson() as String,
      //'ligne_commandes': ligneCommandes.map((ligneCommandes) => ligneCommandes.toJson()).toList().toString(),
    };
  }
}

/// Manage Currency
class Monnaie {
  int? id;
  String? libelle;
  String? symbole;

  Monnaie({this.id, this.libelle, this.symbole});

  factory Monnaie.fromJson(Map<String, dynamic>json){
    return Monnaie(
        id: json['id'],
        libelle: json['libelle'],
        symbole: json['symbole'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'libelle': libelle,
      'symbole': symbole,
    };
  }
}
/// Manage Countries
class Pays {
  int? id;
  String? libelle;
  String? code;

  Pays({this.id, this.libelle, this.code});

  factory Pays.fromJson(Map<String, dynamic>json){
    return Pays(
        id: json['id'],
        libelle: json['libelle'],
        code: json['code'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'libelle': libelle,
      'code': code,
    };
  }

}