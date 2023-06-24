
//import 'package:flutter/material.dart';

class Produit{
  int? id;
  String? libelle;
  double? prix;
  String? image;

  Produit(this.id, this.libelle, this.prix, this.image);
}

List<Produit> product = [
  Produit(1, 'Chemise 1', 20000, 'assets/images/chemise1.jpg'),
  Produit(2, 'Chemise tunique courte femme', 30000, 'assets/images/chemise2.png'),
  Produit(3, 'Robe courte en pagne', 40000, 'assets/images/robe1.png'),
  Produit(4, 'Veste en pagne', 50000, 'assets/images/veste1.jpg'),
  Produit(5, 'Chemise 1', 60000, 'assets/images/chemise1.jpg'),
  Produit(6, 'Chemise 2', 70000, 'assets/images/chemise2.png')
];