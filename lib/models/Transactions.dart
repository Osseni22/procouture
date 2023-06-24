import'package:procouture/models/ConfigData.dart';
import'package:procouture/models/TypeTransaction.dart';
import'package:procouture/models/CategorieDepense.dart';

class Reglement{

  int? id;
  String? ref;
  int? transaction_id;
  int? montant_du;
  int? commande_id;
  int? status;
  Transaction? transaction;

  Reglement({
    required this.id,
    required this.ref,
    required this.transaction_id,
    required this.montant_du,
    required this.commande_id,
    required this.status,
    this.transaction
  });

  // Get Reglement from Json data
  factory Reglement.fromJson(Map<String, dynamic> json){
    return Reglement(
      id: json['id'],
      ref: json['ref'],
      transaction_id: json['transaction_id'],
      montant_du: json['montant_du'],
      commande_id: json['commande_id'],
      status: json['status'],
      transaction: json['transaction'] != null ? Transaction.fromJson(json['transaction'] as Map<String, dynamic>) : null
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'ref': ref,
      'date': transaction_id,
      'montant_du': montant_du,
      'commande_id': commande_id,
      'status': status,
    };
  }

}

class Transaction {
  int? id;
  String? libelle;
  String? date;
  int? montant;
  int? atelier_id;
  int? mode_reglement_id;
  int? categorie_depense_id;
  int? user_id;
  int? type_transaction_id;
  int? base_id;
  CategorieDepense? categorie_depense;
  ModeReglement? mode_reglement;
  //TypeTransaction? type_transaction;

  Transaction({
    required this.id,
    required this.libelle,
    required this.date,
    required this.montant,
    required this.atelier_id,
    required this.mode_reglement_id,
    required this.categorie_depense_id,
    required this.user_id,
    required this.type_transaction_id,
    required this.base_id,
    this.mode_reglement,
    this.categorie_depense,
    //this.type_transaction,
  });

  // Get Transaction from Json data
  factory Transaction.fromJson(Map<String, dynamic> json){
    return Transaction(
      id: json['id'],
      libelle: json['libelle'],
      date: json['date'],
      montant: json['montant'],
      atelier_id: json['atelier_id'],
      mode_reglement_id: json['mode_reglement_id'],
      categorie_depense_id: json['categorie_depense_id'],
      user_id: json['user_id'],
      type_transaction_id: json['type_transaction_id'],
      base_id: json['base_id'],
      mode_reglement: json['mode_reglement'] != null ? ModeReglement.fromJson(json['mode_reglement'] as Map<String, dynamic>) : null,
      //type_transaction: json['type_transaction'] != null ? TypeTransaction.fromJson(json['type_transaction'] as Map<String, dynamic>) : null,
      categorie_depense: json['categorie_depense'] != null ? CategorieDepense.fromJson(json['categorie_depense'] as Map<String, dynamic>) : null,
    );
  }
}

class TransactionU {
  int? id;
  String? libelle;
  String? date;
  int? montant;
  int? atelier_id;
  int? mode_reglement_id;
  int? categorie_depense_id;
  int? user_id;
  int? type_transaction_id;
  int? base_id;
  String? categorie_depense;
  String? mode_reglement;
  //TypeTransaction? type_transaction;

  TransactionU({
    required this.id,
    required this.libelle,
    required this.date,
    required this.montant,
    required this.atelier_id,
    required this.mode_reglement_id,
    required this.categorie_depense_id,
    required this.user_id,
    required this.type_transaction_id,
    required this.base_id,
    this.mode_reglement,
    this.categorie_depense,
    //this.type_transaction,
  });

  // Get Transaction from Json data
  factory TransactionU.fromJson(Map<String, dynamic> json){
    return TransactionU(
      id: json['id'],
      libelle: json['libelle'],
      date: json['date'],
      montant: json['montant'],
      atelier_id: json['atelier_id'],
      mode_reglement_id: json['mode_reglement_id'],
      categorie_depense_id: json['categorie_depense_id'],
      user_id: json['user_id'],
      type_transaction_id: json['type_transaction_id'],
      base_id: json['base_id'],
      mode_reglement: json['mode_reglement']/* != null ? ModeReglement.fromJson(json['mode_reglement'] as Map<String, dynamic>) : null*/,
      //type_transaction: json['type_transaction'] != null ? TypeTransaction.fromJson(json['type_transaction'] as Map<String, dynamic>) : null,
      categorie_depense: json['categorie_depense']/* != null ? CategorieDepense.fromJson(json['categorie_depense'] as Map<String, dynamic>) : null*/,
    );
  }
}
