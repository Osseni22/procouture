class Commande{
  // Member Variables
  int? id;
  String? ref;
  String? date_commande;
  double? montant_recu;
  double? montant_total;
  double? remise;
  String? date_prev_livraison;
  String? date_livraison;
  String? date_essaie;
  int? tva_id;
  int? etat_id;
  int? etat_solde_id;
  int? client_id;
  int? user_id;

  // Constructor
  Commande({
    required this.id,
    required this.ref,
    required this.date_commande,
    required this.montant_recu,
    required this.montant_total,
    required this.remise,
    required this.date_prev_livraison,
    required this.date_livraison,
    required this.date_essaie,
    required this.tva_id,
    required this.etat_id,
    required this.etat_solde_id,
    required this.client_id,
    required this.user_id,
  });

  // Get instance data from a json data
  factory Commande.fromJson(Map<String, dynamic> json){
    return Commande(
        id: json['id'],
        ref: json['ref'],
        date_commande: json['date_commande'],
        montant_recu: json['montant_recu'],
        montant_total: json['montant_total'],
        remise: json['remise'],
        date_prev_livraison: json['date_prev_livraison'],
        date_livraison: json['date_livraison'],
        date_essaie: json['date_essaie'],
        tva_id: json['tva_id'],
        etat_id: json['etat_id'],
        etat_solde_id: json['etat_solde_id'],
        client_id: json['client_id'],
        user_id: json['user_id'],
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'ref': ref,
      'date_commande': date_commande,
      'montant_recu': montant_recu,
      'montant_total': montant_total,
      'remise': remise,
      'date_prev_livraison': date_prev_livraison,
      'date_livraison': date_livraison,
      'date_essaie': date_essaie,
      'tva_id': tva_id,
      'etat_id': etat_id,
      'etat_solde_id': etat_solde_id,
      'client_id': client_id,
      'user_id': user_id,
    };
  }

}