import 'package:procouture/models/CategorieVetement.dart';
import 'package:procouture/models/Client.dart';
import 'package:procouture/models/Product.dart';
import 'package:procouture/models/ConfigData.dart';

class CnxInfo{
  static String? deviceName;
  static int? userID;
  static String? userLastName;
  static String? userFirstName;
  static String? userEmail;
  static int? atelierID;
  static String? token;
  static String? symboleMonnaie;
  static String? atelierLibelle;
}

class CnxInfoAdmin{
  static String? deviceName;
  static int? admin_id;
  static int? compte_id;
  static String? libelle;
  static String? identifiant;
  static String? adminEmail;
  static int? solde;
  static String? token;
  static String? telephone_mobile;
  static String? telephone_fix;
  static String? logo;
}

class Globals{

  /// Global variables
  static int modeleSource = 0;
  static int albumLength = 0;
  static bool isOK = false;

  static bool? isSaved = false;
  static bool? isAdmin = false;
  static String? emailUsername;
  static String? password;

  static Map<String, String> apiHeaders = {
    'Accept':'application/json',
    'Content-Type':'application/json',
    'Authorization':'Bearer ${CnxInfo.token!}',
  };

  /// Global functions
  // Convert a french date to an english date
  static String? convertDateFrToEn(String dateValue){
    return ('${dateValue.substring(6,10)}-${dateValue.substring(3,5)}-${dateValue.substring(0,2)}');
  }

  // Convert a french date to server date format
  static String? convertDateServerFormat(String frenchDate){
    return (frenchDate.replaceAll('/', '-'));
  }

  // Convert an english date to a french date
  static String? convertDateEnToFr(String dateValue){
    return ('${dateValue.substring(8,10)}/${dateValue.substring(5,7)}/${dateValue.substring(0,4)}');
  }

  // Convert a date to Int
  static int convertEnDateToInt(String dateValue){
    return int.parse('${dateValue.substring(6,10)}${dateValue.substring(3,5)}${dateValue.substring(0,2)}');
  }

}

class CmdeVar{

  /// CLIENTS
  static List<Client> allClients = [];
  static List<Client> foundClients = [];
  static Client? selectedClient;

  /// PRODUCTS ET CATEGORIES
  // Categories
  static List<CategorieVetement> allCategories = [];
  static CategorieVetement? selectedCategorieVetement;
  static int? selectedCatVetIndex = 0;

  // Products
  static List<Product> allProducts = [];
  static List<Product> productsByCategorie = [];
  static Product? selectedProduct;
  static List<bool> checked = [];

  /// TVA
  static List<Tva> allTauxTva = [];
  static Tva? selectedTva;

  /// MODE REGLEMENTS
  static List<ModeReglement> allModeReglements = [];
  static ModeReglement? selectedModeReg;

}
