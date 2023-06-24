class Paiement {

  String? nom;
  String? type_paiement;
  int? id;
  String? ref;
  String? date_paiement;
  String? observation;
  int? montant_current_comission;
  int? montant_current_avance;
  int? montant_avance_deduit;
  int? montant_comission_paye;
  int? montant_salaire_paye;
  int? mois;
  int? annee;
  int? transaction_id;
  int? employe_id;
  int? type_paiement_id;
  int? categorie_depense_id;
  int? user_id;
  int? status;

  Paiement({
    required this.nom,
    required this.type_paiement,
    required this.id,
    required this.ref,
    required this.date_paiement,
    required this.observation,
    required this.montant_current_comission,
    required this.montant_current_avance,
    required this.montant_avance_deduit,
    required this.montant_comission_paye,
    required this.montant_salaire_paye,
    required this.mois,
    required this.annee,
    required this.transaction_id,
    required this.employe_id,
    required this.type_paiement_id,
    required this.categorie_depense_id,
    required this.user_id,
    required this.status,
  });

  factory Paiement.fromJson(Map<String, dynamic> json){
    return Paiement(
      nom: json['nom'],
      type_paiement: json['type_paiement'],
      id: json['id'],
      ref: json['ref'],
      date_paiement: json['date_paiement'],
      observation: json['observation'],
      montant_current_comission: json['montant_current_comission'],
      montant_current_avance: json['montant_current_avance'],
      montant_avance_deduit: json['montant_avance_deduit'],
      montant_comission_paye: json['montant_comission_paye'],
      montant_salaire_paye: json['montant_salaire_paye'],
      mois: json['mois'],
      annee: json['annee'],
      transaction_id: json['transaction_id'],
      employe_id: json['employe_id'],
      type_paiement_id: json['type_paiement_id'],
      categorie_depense_id: json['categorie_depense_id'],
      user_id: json['user_id'],
      status: json['status'],
    );
  }

}