import 'package:procouture/models/Product.dart';
import 'package:procouture/models/Client.dart';
import 'package:procouture/models/Etat.dart';

class TacheLibre{
  // Member Variables
  int? id;
  String? nom;
  String? date_debut;
  String? description;
  int? qte;
  int? comission;
  String? nom_particulier;
  int? client_id;
  int? etat_id;
  int? catalogue_id;
  int? employe_id;
  int? montant;
  Product? product;
  Client? client;
  Etat? etat;

  // Constructor
  TacheLibre({
    required this.id,
    required this.date_debut,
    required this.nom,
    required this.description,
    required this.qte,
    required this.nom_particulier,
    required this.etat_id,
    required this.client_id,
    required this.comission,
    required this.catalogue_id,
    required this.employe_id,
    required this.montant,
    this.product,
    this.client,
    this.etat,
  });

  // Get instance data from a json data
  factory TacheLibre.fromJson(Map<String, dynamic> json){
    return TacheLibre(
        id: json['id'],
        date_debut: json['date_debut'],
        nom: json['nom'],
        description: json['description'],
        qte: json['qte'],
        nom_particulier: json['nom_particulier'],
        etat_id: json['etat_id'],
        client_id: json['client_id'],
        comission: json['comission'],
        catalogue_id: json['catalogue_id'],
        employe_id: json['employe_id'],
        montant: json['montant'],
        product: json['catalogue'] != null ? Product.fromJson(json['catalogue'] as Map<String, dynamic>) : null,
        client: json['client'] != null ? Client.fromJson(json['client'] as Map<String, dynamic>) : null,
        etat: json['catalogue'] != null ? Etat.fromJson(json['etat'] as Map<String, dynamic>) : null,
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'ref': date_debut,
      'nom': nom,
      'adresse': description,
      'ville': qte,
      'telephone': nom_particulier,
      'salaire': etat_id,
      'email': client_id,
      'comission': comission,
      'poste_id': montant,
      'active': employe_id,
      'avance_salaire': catalogue_id,
    };
  }
}