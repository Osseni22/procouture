// Pour créer une liste définie de pays
class Country {
  int? id;
  String? nameFrench;
  String? nameEnglish;

  Country(this.id,this.nameFrench,this.nameEnglish);
}
List<Country> countryList = [
  Country(1, "Afrique du Sud", "englishName"),
  Country(2, "Algérie", "englishName"),
  Country(3, "Allemagne", "englishName"),
  Country(4, "Angola", "englishName"),
  Country(5, "Arabie saoudite", "englishName"),
  Country(6, "Belgique", "englishName"),
  Country(7, "Bénin", "englishName"),
  Country(8, "Burkina Faso", "englishName"),
  Country(9, "Burundi", "englishName"),
  Country(10, "Cambodge", "englishName"),
  Country(11, "Cameroun", "englishName"),
  Country(12, "Cap-Vert", "englishName"),
  Country(13, "République centrafricaine", "englishName"),
  Country(14, "République démocratique du Congo", "englishName"),
  Country(15, "Congo", "englishName"),
  Country(16, "Côte d'Ivoire", "englishName"),
  Country(17, "Égypte", "englishName"),
  Country(18, "Éthiopie", "englishName"),
  Country(19, "France", "englishName"),
  Country(20, "Gabon", "englishName"),
  Country(21, "Gambie", "englishName"),
  Country(22, "Ghana", "englishName"),
  Country(23, "Guinée", "englishName"),
  Country(24, "Guinée-Bissau", "englishName"),
  Country(25, "Guinée équatoriale", "englishName"),
  Country(26, "Kenya", "englishName"),
  Country(27, "Liberia", "englishName"),
  Country(28, "Madagascar", "englishName"),
  Country(29, "Mali", "englishName"),
  Country(30, "Maroc", "englishName"),
  Country(31, "Mauritanie", "englishName"),
  Country(32, "Mozambique", "englishName"),
  Country(33, "Namibie", "englishName"),
  Country(34, "Niger", "englishName"),
  Country(35, "Nigeria", "englishName"),
  Country(36, "Ouganda", "englishName"),
  Country(37, "Royaume-Uni", "englishName"),
  Country(38, "Sénégal", "englishName"),
  Country(39, "Somalie", "englishName"),
  Country(40, "Soudan", "englishName"),
  Country(41, "Tanzanie", "englishName"),
  Country(42, "Tchad", "englishName"),
  Country(43, "Togo", "englishName"),
  Country(44, "Tunisie", "englishName"),
  Country(45, "Zambie", "englishName"),
  Country(46, "Zimbabwe", "englishName"),
  Country(47, "Autres", "englishName")
];

// Pour créer une liste définie de monnaie
class Monnaie {
  int? id;
  String? frenchName;
  String? englishName;

  Monnaie(this.id,this.frenchName,this.englishName);
}
List<Monnaie> monnaieList = [
  Monnaie(1, "Non définie", "Undefined"),
  Monnaie(2, "FCFA", "Undefined"),
  Monnaie(3, "€", "Undefined"),
  Monnaie(4, "\$", "Undefined"),
  Monnaie(5, "£", "Undefined"),
  Monnaie(6, "DT", "Undefined"),
  Monnaie(7, "GH₵", "Undefined"),
  Monnaie(8, "MAD", "Undefined"),
  Monnaie(9, "R", "Undefined"),
  Monnaie(10, "E£", "Undefined"),
  Monnaie(10, "F", "Undefined")
];

// Pour créer une liste définie de noms de mesure
class NomMesure{
  String? nom;
  int? order;

  NomMesure(this.nom, this.order);
}
List<NomMesure> nomMesureList = [
  NomMesure('Nom mesure 1',1),
  NomMesure('Nom mesure 2',2),
  NomMesure('Nom mesure 3',3),
  NomMesure('Nom mesure 4',4),
  NomMesure('Nom mesure 5',5),
  NomMesure('Nom mesure 6',6),
  NomMesure('Nom mesure 7',7),
  NomMesure('Nom mesure 8',8),
  NomMesure('Nom mesure 9',9),
  NomMesure('Nom mesure 10',10),
  NomMesure('Nom mesure 11',11),
  NomMesure('Nom mesure 12',12),
  NomMesure('Nom mesure 13',13),
  NomMesure('Nom mesure 14',14)
];