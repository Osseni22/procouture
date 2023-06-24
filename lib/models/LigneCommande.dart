import 'package:procouture/models/Product.dart';
class LigneCommande {

  // Members
  int? id;
  int? qte;
  int? prix;
  int? qte_confection_done;
  int? qte_retrait;
  String? description;
  String? image_matiere;
  int? etat_id;
  int? etat_retrait_id;
  int? commande_id;
  int? catalogue_id;
  String? image_av;
  Product? product;

  // Constructor
  LigneCommande({
    required this.id,
    required this.qte,
    required this.prix,
    required this.qte_confection_done,
    required this.qte_retrait,
    required this.description,
    required this.image_matiere,
    required this.etat_id,
    required this.etat_retrait_id,
    required this.commande_id,
    required this.catalogue_id,
    required this.image_av,
    this.product
  });

  // Get instance data from a json data
  factory LigneCommande.fromJson(Map<String, dynamic> json){
    return LigneCommande(
      id: json['id'],
      qte: json['qte'],
      prix: json['prix'],
      qte_confection_done: json['qte_confection_done'],
      qte_retrait: json['qte_retrait'],
      description: json['description'],
      image_matiere: json['image_matiere'],
      etat_id: json['etat_id'],
      etat_retrait_id: json['etat_retrait_id'],
      commande_id: json['commande_id'],
      catalogue_id: json['catalogue_id'],
      image_av: json['image_av'],
      product: json['catalogue'] != null ? Product.fromJson(json['catalogue'] as Map<String, dynamic>) : null
    );
  }

  // Convert to Json
  Map<String, String> toJson(){
    return {
      'id': id.toString(),
      'qte': qte.toString(),
      'prix': prix.toString(),
      'qte_confection_done': qte_confection_done.toString(),
      'qte_retrait': qte_retrait.toString(),
      'description': description.toString(),
      'image_matiere': image_matiere.toString(),
      'etat_id': etat_id.toString(),
      'etat_retrait_id': etat_retrait_id.toString(),
      'commande_id': commande_id.toString(),
      'catalogue_id': catalogue_id.toString(),
      'image_av': image_av.toString(),
    };
  }

}