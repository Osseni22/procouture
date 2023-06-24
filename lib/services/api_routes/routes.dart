/// Ici toutes les routes (liens http) d'accès aux fonctionnalités de l'application.

// l'adresse web de base
//const String Root = "https://api.procouture.app";

const String Root = "https://api.procouture.shop";

/// PARTIE USER

// Login
const String r_login = "$Root/api/login";

// Afficher la liste des ateliers
const String r_ateliers = "$Root/api/ateliers";

// Gestion des clients
const String r_client = "$Root/api/clients";

// Gestion des produits
const String r_product = "$Root/api/catalogues";

// Gestion des commandes
const String r_commande = "$Root/api/commandes";

// Informations pour enregistrer une commande
const String r_commandeInfos = "$Root/api/commandes/new-infos";

// Afficher la liste des pays et des monnaies
const String r_registerInfos = "$Root/api/register-info";

// Inscription
const String r_register = "$Root/api/register";

// Gestion des règlements
const String r_reglement = "$Root/api/reglements";

/// TRESORERIE USER

// Affichage des banques pour un user normal
const String r_banquesUser = "$Root/api/tresorerie/banques";

// Affichage de la tresorerie générale pour un user normal
const String r_tresorerieGenerale = "$Root/api/tresorerie";

// Affichage de la tresorerie boutique pour un user normal
const String r_tresorerieBoutique = "$Root/api/tresorerie/boutique";

// Affichage de la tresorerie confection pour un user normal
const String r_tresorerieConfection = "$Root/api/tresorerie/confections";

// Ajouter une nouvelle recette
const String r_tresorerieNewRecette = "$Root/api/tresorerie/recettes";

// Ajouter une nouvelle dépense
const String r_tresorerieNewDepense = "$Root/api/tresorerie/depenses";

// Afficher les categories de dépense
const String r_categorieDepense = "$Root/api/categorie-depenses-show";

// Afficher les creanciers
const String r_confectionsCreanciers = "$Root/api/tresorerie/confection/creanciers";

// Afficher les transactions confections
const String r_transactionsBanque = "$Root/api/tresorerie/transactions-banques";

/* GESTION DU PERSONNEL */
// employe
const String r_employes = "$Root/api/employes";
// poste
const String r_postes = "$Root/api/get-employe-postes";
// avances
const String r_avances = "$Root/api/avances";
// paiements
const String r_paiements = "$Root/api/paiements";

/// PARTIE ADMIN
class AdminRoutes {

  // Login Admin
  static const String r_adminLogin = "$Root/api/compte/login";

  // Gestion des ateliers
  static const String r_adminAtelier = "$Root/api/ateliers";

  // Affichage des banques pour un admin
  static String r_getBanquesUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/banques";
  }
  // Affichage des clients pour un admin
  static String r_getClientsUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/clients";
  }
  // Affichage des fournisseurs pour un admin
  static String r_getFournisseursUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/fournisseurs";
  }
  // Affichage des commandes pour un admin
  static String r_getCommandesUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/commandes";
  }
  // Affichage des employés pour un admin
  static String r_getEmployesUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/employes";
  }
  // Affichage des tresorerie pour un admin
  static String r_getTresorerieUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tresorerie";
  }
  // Affichage des tâches libres pour un admin
  static String r_getTachesLibresUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tache-libre";
  }

  /// TRANSACTIONS
  // Affichage de la tresorerie générale pour un admin
  static String r_getTresorerieGeneraleUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tresorerie";
  }
  // Affichage de la tresorerie confection pour un admin
  static String r_getTresorerieConfectionUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tresorerie/confections";
  }
  // Affichage de la tresorerie boutique pour un admin
  static String r_getTresorerieBoutiqueUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tresorerie/boutique";
  }

  // Affichage des transactions confection pour un admin
  static String r_getTransactionConfectionUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tresorerie/confections/transactions";
  }

  // Affichage des transactions boutique pour un admin
  static String r_getTransactionBoutiqueUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tresorerie/boutique/transactions";
  }

  // Affichage des transactions confection pour un admin
  static String r_getTransactionConfectionCreancierUrl(int atelierId){
    return "$Root/api/ateliers/$atelierId/tresorerie/confection/creanciers";
  }

  // Affichage des transactions d'une banque pour un admin
  static String r_getTransactionBanqueCreancierUrl(int atelierId, int banqueId){
    return "$Root/api/ateliers/$atelierId/tresorerie/transactions-banques/$banqueId";
  }

}

