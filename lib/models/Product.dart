class Product{
  int? id;
  String? ref;
  String? libelle;
  int? prix_ht;
  String? image_av;
  String? image_ar;
  int? categorie_vetement_id;
  int? base_modele_id;

  Product({
    required this.id,
    required this.ref,
    required this.libelle,
    required this.prix_ht,
    required this.image_av,
    required this.image_ar,
    required this.categorie_vetement_id,
    required this.base_modele_id,
  });

  // Get product from Json data
  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      ref: json['ref'],
      libelle: json['libelle'],
      prix_ht: json['prix_ht'],
      image_av: json['image_av'],
      image_ar: json['image_ar'],
      categorie_vetement_id: json['categorie_vetement_id'],
      base_modele_id: json['base_modele_id'],
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'ref': ref,
      'libelle': libelle,
      'prix_ht': prix_ht,
      'image_av': image_av,
      'image_ar': image_ar,
      'categorie_vetement_id': categorie_vetement_id,
      'base_modele_id': base_modele_id,
    };
  }

}