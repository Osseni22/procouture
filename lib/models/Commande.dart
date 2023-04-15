import 'LigneCommande.dart';

class Commande {
  // Member Variables
  int? id;
  String? ref;
  String? date_commande;
  int? montant_recu;
  int? montant_ht;
  int? montant_ttc;
  int? remise;
  String? date_prev_livraison;
  String? date_livraison;
  String? date_essaie;
  String? client;
  String? email;
  String? etat;
  int? tva_id;
  int? etat_id;
  int? etat_solde_id;
  int? etat_retrait_id;
  int? client_id;
  int? user_id;
  List<LigneCommande>? ligne_commandes;

  // Constructor
  Commande({
    required this.id,
    required this.ref,
    required this.date_commande,
    required this.montant_recu,
    required this.montant_ht,
    required this.montant_ttc,
    required this.remise,
    required this.date_prev_livraison,
    required this.date_livraison,
    required this.date_essaie,
    required this.client,
    required this.email,
    required this.etat,
    required this.tva_id,
    required this.etat_id,
    required this.etat_solde_id,
    required this.etat_retrait_id,
    required this.client_id,
    required this.user_id,
    this.ligne_commandes,
  });

  // Get instance data from a json data
  factory Commande.fromJson(Map<String, dynamic> json){
    return Commande(
        id: json['id'],
        ref: json['ref'],
        date_commande: json['date_commande'],
        montant_recu: json['montant_recu'],
        montant_ht: json['montant_ht'],
        montant_ttc: json['montant_ttc'],
        remise: json['remise'],
        client: json['client'],
        email: json['email'],
        etat: json['etat'],
        date_prev_livraison: json['date_prev_livraison'],
        date_livraison: json['date_livraison'],
        date_essaie: json['date_essaie'],
        tva_id: json['tva_id'],
        etat_id: json['etat_id'],
        etat_solde_id: json['etat_solde_id'],
        etat_retrait_id: json['etat_retrait_id'],
        client_id: json['client_id'],
        user_id: json['user_id'],
    );
  }

  // Convert to Json
  Map<String, String> toJson(List<LigneCommande> ligneCommandes){
    return {
      'id': id.toString(),
      'ref': ref.toString(),
      'date_commande': date_commande.toString(),
      'montant_recu': montant_recu.toString(),
      'montant_ht': montant_ht.toString(),
      'montant_ttc': montant_ttc.toString(),
      'remise': remise.toString(),
      'client': client.toString(),
      'email': email.toString(),
      'etat': etat.toString(),
      'date_prev_livraison': date_prev_livraison.toString(),
      'date_livraison': date_livraison.toString(),
      'date_essaie': date_essaie.toString(),
      'tva_id': tva_id.toString(),
      'etat_id': etat_id.toString(),
      'etat_solde_id': etat_solde_id.toString(),
      'etat_retrait_id': etat_retrait_id.toString(),
      'client_id': client_id.toString(),
      'user_id': user_id.toString(),
      'ligne_commandes': ligneCommandes.map((ligneCommandes) => ligneCommandes.toJson()).toList().toString(),
    };
  }

}
