import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:procouture/models/Client.dart';
import 'package:procouture/models/LigneCommande.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../components/message_box.dart';
import '../../../models/CategorieVetement.dart';
import '../../../models/Commande.dart';
import '../../../models/Product.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';

class CommandeSavePage extends StatefulWidget {

  final String pageMode; Commande? cmde; List<LigneCommande>? ligneCdes;
  CommandeSavePage({Key? key, required this.pageMode, this.cmde,this.ligneCdes,}) : super(key: key);

  @override
  State<CommandeSavePage> createState() => _CommandeSavePageState();
}

class _CommandeSavePageState extends State<CommandeSavePage> {

  bool isLoading = false;
  bool isVisible = false;
  //double fieldHeight = 40;


  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// CLIENTS
  List<Client> allClients = [];
  List<Client> foundClients = [];
  late Client selectedClient;

  /// PRODUCTS ET CATEGORIES
  // Categories
  List<CategorieVetement> allCategories = [];
  late CategorieVetement selectedCategorieVetement;
  int? selectedCatVetIndex;

  // Products
  List<Product> allProducts = [];
  List<Product> productsByCategorie = [];
  late Product selectedProduct;
  List<bool> checked = [];

  /// COMMANDE ET LIGNES COMMMANDES
  late Commande commande;
  List<LigneCommande> ligneCommandes = [];
  late LigneCommande selectedLigneCmde;

  /// DATE CONTROLLERS
  TextEditingController dateCmdeCtrl = TextEditingController();
  TextEditingController dateLivraisonCtrl = TextEditingController();
  TextEditingController dateEssaiCtrl = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');
  /// CLIENT CONTROLLERS
  TextEditingController clientCtrl = TextEditingController();

  /// LIGNE COMMANDE EDIT CONTROLLERS
  TextEditingController libelleCtrl = TextEditingController();
  TextEditingController qteCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController prixUnitaireCtrl = TextEditingController();
  TextEditingController prixTotalCtrl = TextEditingController();

  /// TAKING PICTURES
  File? _imageFile;
  File? _imageFileCompressed;
  final _picker = ImagePicker();
  Future<void> takePicture(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  /// AMOUNTS
  late int montantRemise;
  late int montantHT;
  late int montantTTC;
  //late int netCom;

  List<int> itemsTva = [0, 18, 20, 23, 25];
  int selectedTva = 0; // default selected tva

  /// REMISE AND TVA CONTROLLERS
  TextEditingController tauxRemiseCtrl = TextEditingController(text: '0');
  TextEditingController valeurRemiseCtrl = TextEditingController(text: '0');
  TextEditingController valeurTVACtrl = TextEditingController(text: '0');

  @override
  void initState() {
    // Load all fundamentals
    getAllProductsAndCategories();
    getAllClient();

/*    print(allClients);
    print(allProducts);
    print(allCategories);*/

    // Initialize the checked list with all false values
    checked = List<bool>.filled(productsByCategorie.length, false);

    if(widget.pageMode == 'A'){
      // All amount fields to zero
      initializeAllAmounts();
      // Get today's date in 'date commande field'
      dateCmdeCtrl.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    } else {
      // Give all information in edit mode
      setData();
    }

    super.initState();
  }
  @override
  void dispose() {
    clientCtrl.dispose();
    dateCmdeCtrl.dispose();
    dateLivraisonCtrl.dispose();
    dateEssaiCtrl.dispose();
    libelleCtrl.dispose();
    qteCtrl.dispose();
    descriptionCtrl.dispose();
    prixUnitaireCtrl.dispose();
    prixTotalCtrl.dispose();
    tauxRemiseCtrl.dispose();
    valeurRemiseCtrl.dispose();
    valeurTVACtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar('Fiche Commande', context),
      body: isLoading? const LinearProgressIndicator(backgroundColor: Colors.transparent) : body(),
    );
  }

  /// PAGE PRINCIPALE
  Widget body(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Date Cmde et Client
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Date Commande'),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      //border: Border.all(color: Colors.grey.withOpacity(0.5))
                    ),
                    child: DateTimeField(
                      resetIcon: null,
                      style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                      format: format,
                      controller: dateCmdeCtrl,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '__/__/____',
                          hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                      ),
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                    ),
                  )
                ],
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label('Client'),
                    Container(
                      alignment: Alignment.center,
                      //width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: clientCtrl,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Choisir un client',
                                hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                              ),
                              onTap: (){
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (ctx) => selectClient(),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14.0),
                                    ),
                                  ),
                                );
                                //print(selectedClient?.nom!);
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: (){
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (ctx) => selectClient(),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14.0),
                                    ),
                                  ),
                                );
                                //scaffoldKey.currentState?.setState(() {});
                                //print(selectedClient?.nom!);
                              },
                              icon: Icon(Icons.arrow_drop_down, color: Colors.black,)
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15,),
        /// Button ajout modèle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () async {
              Globals.modeleSource = 0;
              await showModeleSourcePage(context);
              if(Globals.modeleSource == 1) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => selectModele(),
                  shape: const RoundedRectangleBorder( // <-- SEE HERE
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                );
              } else if (Globals.modeleSource == 2) {
                Fluttertoast.showToast(msg: 'Disponible ultérieurement');
              } else if (Globals.modeleSource == 3) {
                Fluttertoast.showToast(msg: 'Disponible ultérieurement');
              }
              setState(() {
                calculMontantTTC();
              });
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kProcouture_green
              ),
              child: Row(
                children: [
                  Expanded(
                      child: textMontserrat('Ajouter un modèle', 15, Colors.white, TextAlign.center, fontWeight: FontWeight.w500)
                  ),
                  Icon(Icons.add, color: Colors.white,),
                  SizedBox(width: 5,)
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        /// Affichage des modèles
        Center(
          child: label('Modèles de la commande'),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: ligneCommandes.isNotEmpty ? buildLigneCommandes() : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Center(
                child: Text('Aucun modèle ajouté pour cette commande'),
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        /// Gestion des dates
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Date Livraison'),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      //border: Border.all(color: Colors.grey.withOpacity(0.5))
                    ),
                    child: DateTimeField(
                      resetIcon: null,
                      style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                      format: format,
                      controller: dateLivraisonCtrl,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '__/__/____',
                          hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                      ),
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                    ),
                  )
                ],
              ),
              SizedBox(width: 30,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Date Essai'),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      //border: Border.all(color: Colors.grey.withOpacity(0.5))
                    ),
                    child: DateTimeField(
                      resetIcon: null,
                      style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                      format: format,
                      controller: dateEssaiCtrl,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '__/__/____',
                          hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                      ),
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),

        /// Application remise ou TVA
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            alignment: Alignment.center,
            height: isVisible ? 80 : 0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [kDefaultBoxShadow]
            ),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Remise(%)'),
                      Container(
                        width: 60,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          controller: tauxRemiseCtrl,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                          ),
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                valeurRemiseCtrl.text = '0';
                                tauxRemiseCtrl.text = '0';
                                montantRemise = 0;
                                calculMontantTTC();
                              });
                            } else {
                              double taux = double.parse(value);
                              if(taux > 100) {
                                taux = 100;
                                tauxRemiseCtrl.text = '100';
                              }
                              if(taux < 0){
                                taux = 0;
                                tauxRemiseCtrl.text = '0';
                              }
                              setState(() {
                                tauxRemiseCtrl.text = int.parse(tauxRemiseCtrl.text).toString();
                                valeurRemiseCtrl.text = ((taux * montantHT)/100).round().toString();
                                montantRemise = int.parse(valeurRemiseCtrl.text);
                                calculMontantTTC();
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Montant remise'),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          //border: Border.all(color: Colors.grey.withOpacity(0.5))
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          controller: valeurRemiseCtrl,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                          ),
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                valeurRemiseCtrl.text = '0';
                                tauxRemiseCtrl.text = '0';
                                montantRemise = 0;
                                calculMontantTTC();
                              });
                            } else {
                              int valeur = int.parse(value);
                              if(valeur > montantHT) {
                                valeur = montantHT;
                                valeurRemiseCtrl.text = montantHT.toString();
                              }
                              setState(() {
                                valeurRemiseCtrl.text = int.parse(valeurRemiseCtrl.text).toString();
                                tauxRemiseCtrl.text = ((valeur * 100)/montantHT).toStringAsFixed(2);
                                montantRemise = int.parse(valeurRemiseCtrl.text);
                                calculMontantTTC();
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('TVA(%)'),
                      Container(
                        padding: EdgeInsets.only(left:10),
                        width: 60,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          //border: Border.all(color: Colors.grey.withOpacity(0.5))
                        ),
                        child: DropdownButton<int>(
                          alignment: Alignment.center,
                          isExpanded: true,
                          underline: SizedBox(),
                          value: selectedTva,
                          items: itemsTva.map((int number) {
                            return DropdownMenuItem<int>(
                              value: number,
                              child: Text(number.toString()),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            setState(() {
                              selectedTva = value!;
                              calculMontantTTC();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Montant TVA'),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          //border: Border.all(color: Colors.grey.withOpacity(0.5))
                        ),
                        child: TextField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          controller: valeurTVACtrl,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        isVisible ? SizedBox(height: 10) : SizedBox(),
        /// Gestion des montants
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 23.0),
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          child: textMontserrat('Montant remise :', 17, Colors.black, TextAlign.start, fontWeight:FontWeight.w400),
                        )
                    ),
                    Expanded(
                        child: Container(
                          child: textMontserrat(NumberFormat('#,###', 'fr_FR').format(montantRemise), 18, Colors.black, TextAlign.end,fontWeight: FontWeight.bold),
                        )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          child: textMontserrat('Montant HT :', 17, Colors.black, TextAlign.start, fontWeight:FontWeight.w400),
                        )
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                        child: Container(
                          child: textMontserrat(NumberFormat('#,###', 'fr_FR').format(montantHT), 18, Colors.black, TextAlign.end,fontWeight: FontWeight.bold),
                        )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          child: textMontserrat('Montant TTC :', 17, Colors.black, TextAlign.start, fontWeight:FontWeight.w400),
                        )
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                        child: Container(
                          child: textMontserrat(NumberFormat('#,###', 'fr_FR').format(montantTTC), 18, Colors.black, TextAlign.end,fontWeight: FontWeight.bold),
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5,),

        /// Boutons d'actions,
        SizedBox(height: 5,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      if (ligneCommandes.isNotEmpty) {
                        isVisible = !isVisible;
                      } else {
                        if(isVisible){
                          isVisible = false;
                        } else {
                          Fluttertoast.showToast(msg: 'Veuillez renseigner au moins un modèle');
                        }
                      }
                    });
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kProcouture_green.withOpacity(0.15),
                        //border: Border.all(color: Colors.grey)
                    ),
                    child: textMontserrat('TVA / Remise', 13, kProcouture_green, TextAlign.center, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(verificationBeforeSubmitting()){
                        // Json file creation
                        Commande commande = getCommande();
                        print(commande.toJson(ligneCommandes));
                        print(r_commande);
                        createCommande(commande.toJson(ligneCommandes));

                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kProcouture_green
                      ),
                      child: textMontserrat(widget.pageMode == 'A' ? 'Valider la commande': 'Modifier la commande', 13, Colors.white, TextAlign.center, fontWeight: FontWeight.w500),
                    ),
                  )
              ),
            ],
          ),
        ),
        SizedBox(height: 5,),
      ],
    );
  }

  /// PAGE RENSEIGNER DETAIL MODELE
  Container editModeleInfo(String? imageUrl){
    return Container(
      height: 600/*MediaQuery.of(context).size.height * 0.85*/,
      child: StatefulBuilder(
        builder: (BuildContext context, state) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 30,),
                    // La source de selection du modèle
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade400),
                              /*image: DecorationImage(
                                  image: imageUrl == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : NetworkImage(imageUrl),
                                  fit: BoxFit.cover
                              )*/
                          ),
                        ),
                        SizedBox(width: 10),
                        // Image du modèle
                        textMontserrat('Source du modèle :\n Depuis le catalogue', 16, Colors.black, TextAlign.center),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Champs de saisie
                    Container(
                      height: 370,
                      padding:  EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0,10)
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              //color: Colors.white,
                                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width : 100,
                                  padding: const EdgeInsets.only(left : 10.0),
                                  child: textMontserrat('Libelle', 15, Colors.grey, TextAlign.start),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: libelleCtrl,
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Libellé',
                                        hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              //color: Colors.white,
                                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.only(left : 10.0),
                                  child: textMontserrat('Prix Unitaire', 15, Colors.grey, TextAlign.start),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: prixUnitaireCtrl,
                                    readOnly: true,
                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Prix Unitaire',
                                        hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              //color: Colors.white,
                                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.only(left : 10.0),
                                  child: textMontserrat('Quantité', 15, Colors.grey, TextAlign.start),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: qteCtrl,
                                    readOnly: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        //hintText: 'Quantité',
                                        hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.grey.shade200,
                                    child: IconButton(
                                        onPressed: (){
                                          int qte = int.parse(qteCtrl.text);
                                          qte++;
                                          qteCtrl.text = qte.toString();
                                          state(() {
                                            prixTotalCtrl.text = (int.parse(prixUnitaireCtrl.text) * int.parse(qteCtrl.text)).toString();
                                          });
                                        },
                                        icon: Icon(Icons.add, color: Colors.black,)
                                    )
                                ),
                                SizedBox(width: 15,),
                                CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.grey.shade200,
                                    child: IconButton(
                                      onPressed: (){
                                        int qte = int.parse(qteCtrl.text);
                                        if(qte < 2){
                                          qte = 1;
                                        } else {
                                          qte--;
                                        }
                                        qteCtrl.text = qte.toString();
                                        state(() {
                                          prixTotalCtrl.text = (int.parse(prixUnitaireCtrl.text) * int.parse(qteCtrl.text)).toString();
                                        });
                                      },
                                      icon: Icon(Icons.remove, color: Colors.black,),
                                    )
                                ),
                                SizedBox(width: 5,),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.only(left : 10.0),
                                  child: textMontserrat('Prix Total', 15, Colors.grey, TextAlign.start),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: prixTotalCtrl,
                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        //hintText: 'Prix Total',
                                        hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                padding: const EdgeInsets.only(left : 10.0),
                                child: textMontserrat('Description', 15, Colors.grey, TextAlign.start),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: descriptionCtrl,
                                  keyboardType: TextInputType.text,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //hintText: 'Description',
                                      hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    GestureDetector(
                      onTap: () {
                        selectedLigneCmde.qte = int.parse(qteCtrl.text);
                        selectedLigneCmde.prix = int.parse(prixTotalCtrl.text);
                        selectedLigneCmde.description = descriptionCtrl.text;
                        //setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: double.infinity,
                        padding:  EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: kProcouture_green,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 25,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: textMontserrat('Valider', 18, Colors.white, TextAlign.center, fontWeight: FontWeight.w500,),
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// PAGE SELECTION MODELE
  Container selectModele(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: StatefulBuilder(
        builder: (context, state) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 15,),
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 15),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allCategories.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedCatVetIndex = index;
                              runProductFilter(allCategories[index].id.toString());
                            });
                            state(() {
                              selectedCatVetIndex = index;
                              runProductFilter(allCategories[index].id.toString());
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: index == selectedCatVetIndex ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                                border: index == selectedCatVetIndex ? Border.all(color: Colors.black, width: 1) : Border.all(color: Colors.transparent, width: 0),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: textRaleway(allCategories[index].libelle!, 13, Colors.black, TextAlign.start)
                          ),
                        )
                ),
              ),
              SizedBox(height: 15,),
              productsByCategorie.isNotEmpty ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: productsByCategorie.length,
                          itemBuilder: (context, int index2) => Container(
                            child: CheckboxListTile(
                              title: textOpenSans(productsByCategorie[index2].libelle!, 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                              subtitle: textMontserrat(productsByCategorie[index2].prix_ht.toString(), 12, Colors.black, TextAlign.start),
                              value: checked[index2],
                              onChanged: (bool? value) {
                                setState(() {
                                  if (!isAlreadyAdded(productsByCategorie[index2])) {
                                    checked[index2] = value!;
                                  } else {
                                    value = false;
                                    Fluttertoast.showToast(msg: 'Ce modèle a déjà été ajouté !');
                                  }
                                });
                                state(() {
                                  if (!isAlreadyAdded(productsByCategorie[index2])) {
                                    checked[index2] = value!;
                                  } else {
                                    value = false;
                                    //Fluttertoast.showToast(msg: 'Ce modèle a déjà été ajouté !');
                                  }
                                });
                              },
                            ),
                          ),
                        )
                    ),
                  )
              ) :
              Expanded(
                child: Center(
                  child: selectedCatVetIndex == null ? Text("Aucune catégorie de vêtement selectionnée", textAlign: TextAlign.center,):
                  Text("Aucun modèle pour la categorie selectionnée", textAlign: TextAlign.center,)
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () {
                    for(int i = 0; i < checked.length; i++){
                      if(checked[i] == true){
                        LigneCommande ligneCommande = LigneCommande(
                            id: 0, qte: 1, prix: productsByCategorie[i].prix_ht,
                            qte_confection_done: 0, qte_retrait: 0, description: '',
                            image_matiere: null, etat_id: 1, etat_retrait_id: 1, commande_id: 0, catalogue_id: productsByCategorie[i].id, image_av: null
                        );
                        ligneCommandes.add(ligneCommande);
                      }
                    }
                    setState(() {
                      unSelectAll();
                      calculMontantTTC();
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kProcouture_green
                    ),
                    child: textMontserrat('Valider la sélection', 15, Colors.white, TextAlign.center, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  /// ZONE D'AFFICHAGE DES MODELES AJOUTES
  Widget buildLigneCommandes(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: ligneCommandes.length,
          itemBuilder: (context, int index) => Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: GestureDetector(
              onTap: () async {
                // Prepare fields
                selectedLigneCmde = ligneCommandes[index];
                libelleCtrl.text = getLibelleProduct(selectedLigneCmde)!;
                qteCtrl.text = selectedLigneCmde.qte.toString();
                if (selectedLigneCmde.description != null) {
                  descriptionCtrl.text = selectedLigneCmde.description!;
                } else {
                  descriptionCtrl.text = '';
                }
                prixUnitaireCtrl.text = (selectedLigneCmde.prix! / selectedLigneCmde.qte!).round().toString();
                prixTotalCtrl.text = selectedLigneCmde.prix.toString();

                // get Image from server
                /*if (selectedLigneCmde.image_av != '' || selectedLigneCmde.image_av != null) {
                  getImageFileFromNetwork(selectedLigneCmde.image_av.toString());
                }*/

                // show modal
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.grey.shade100,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (ctx) => editModeleInfo(selectedLigneCmde.image_av.toString()),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.0),
                    ),
                  ),
                );

                setState(() {
                  ligneCommandes[index] = selectedLigneCmde;
                  calculMontantTTC();
                });

              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black54,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 2,),
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              // Afficher la quantité et le texte 'montant'
                              Container(
                                width: 70,
                                //color: Colors.grey,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      textMontserrat('Qté:', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                      textMontserrat(ligneCommandes[index].qte.toString(), 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                ),
                              ),
                              // Afficher le libellé et la valeur du montant
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: textMontserrat(getLibelleProduct(ligneCommandes[index])!, 14, Colors.black, TextAlign.center,),
                                        ),
                                        textMontserrat(ligneCommandes[index].prix.toString(), 15, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  )
                              ),
                              // Afficher le bouton de suppression du modèle
                              Container(
                                width: 50,
                                child: IconButton(
                                  onPressed: () async {
                                    if (await msgBoxYesNo('Suppression', 'Supprimer cette ligne de commande ?', context)) {
                                      setState(() {
                                        ligneCommandes.removeAt(index);
                                        if (ligneCommandes.isNotEmpty) {
                                          calculMontantTTC();
                                        } else{
                                          initializeAllAmounts();
                                        }
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.close, color: Colors.black,),
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    SizedBox(width: 2,),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  /// SOURCE DE SELECTION DE MODELE
  Container sourceSelectionModele(){
    return Container(
      height: 90,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textMontserrat('Choisir la source du modèle', 15, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
          Row(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        //pageIndex = 2;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FaIcon(FontAwesomeIcons.blackTie, size: 29,color: Colors.blueGrey),
                          textMontserrat('Catalogue', 13, Colors.blueGrey, TextAlign.start)
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(width: 5,),
              Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(msg: 'Disponible ultérieurement !');
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.camera, size: 29,color: Colors.blueGrey),
                          textMontserrat('Camera', 13, Colors.blueGrey, TextAlign.start)
                        ],
                      ),
                    ),
                  )

              ),
              SizedBox(width: 5,),
              Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Fluttertoast.showToast(msg: 'Disponible ultérieurement !');
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.image, size: 29,color: Colors.blueGrey),
                          textMontserrat('Galerie', 13, Colors.blueGrey, TextAlign.start)
                        ],
                      ),
                    ),
                  )

              ),
            ],
          ),
        ],
      ),
    );
  }

  /// SELECTION DES CLIENTS
  Container selectClient(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StatefulBuilder(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              // Afficher le champ de recherche et le bouton de fermeture
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.search, color: Colors.black,),
                            SizedBox(width: 10,),
                            Expanded(
                              child: TextField(
                                //controller: designationCtrl,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Rechercher un client',
                                  hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                                ),
                                onChanged: (value) {
                                  runClientFilter(value);
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: (){Navigator.pop(context);},
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),

              // Champ de recherche
              SizedBox(height: 5,),
              // Afficher ici la liste des clients
              Expanded(
                child: Container(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: foundClients.length,
                      itemBuilder: (context, int index) => InkWell(
                        onTap: () {
                          selectedClient = foundClients[index];
                          /*scaffoldKey.currentState?.*/setState(() {
                            clientCtrl.text = selectedClient.nom!;
                          });
                          //print(selectedClient?.nom);
                          Navigator.pop(context);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: textLato(index != null ? '${foundClients[index].nom.toString().toUpperCase()}'.substring(0,1) : '', 18, Colors.black, TextAlign.center),
                          ),
                          title: textMontserrat('${foundClients[index].nom}', 16, Colors.black, TextAlign.left, fontWeight: FontWeight.w500),
                          subtitle: textWorkSans('${foundClients[index].telephone1}', 12, Colors.black, TextAlign.left),
                        ),
                      )
                  ),
                ),
              ),
              SizedBox(height: 2,),
            ],
          ),
        ),
      ),
    );
  }

  // to label some fields
  Widget label(String text){
    return textMontserrat(text, 10, Colors.black, TextAlign.start);
  }

  // Compress my Image
  Future<File> compressImage(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 25, // The quality of the compressed image, from 0 to 100.
    );
    return compressedFile;
  }

  // Show progress Indicator
  void showProgress(bool value){
    if(value){
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Run Filter
  void runProductFilter(String categorie_id) {
    List<Product> results = [];
    for(int i = 0; i < allProducts.length; i++){
      if(allProducts[i].categorie_vetement_id.toString() == categorie_id){
        results.add(allProducts[i]);
      }
    }
    productsByCategorie = results;
    checked = List<bool>.filled(productsByCategorie.length, false);
  }
  void runClientFilter(String enteredKeywords){
    List<Client> results = [];
    if(enteredKeywords.isEmpty){
      results = allClients;
    } else {
      results = allClients.where((element) => element.nom.toString().toLowerCase().contains(enteredKeywords.toLowerCase())).toList();
    }
    setState(() {
      foundClients = results;
    });
  }
  // Other functions
  String? getLibelleProduct(LigneCommande ligneCommande){
    for(int i = 0; i < allProducts.length; i++){
      if(ligneCommande.catalogue_id == allProducts[i].id){
        return allProducts[i].libelle;
      }
    }
    return null;
  }
  String? getProductImage(LigneCommande ligneCommande){
    for(int i = 0; i < allProducts.length; i++){
      if(ligneCommande.catalogue_id == allProducts[i].id){
        return allProducts[i].image_av;
      }
    }
    return null;
  }
  int getTvaId(int value){
    int tvaId = 1;
    switch(value){
      case 0:
        tvaId = 1;
        break;
      case 18:
        tvaId = 2;
        break;
      case 20:
        tvaId = 3;
        break;
      case 23:
        tvaId = 4;
        break;
      case 25:
        tvaId = 5;
        break;
      default :
        tvaId = 1;
        break;
    }
    return tvaId;
  }
  int getTvaValue(int value){
    int tvaValue = 0;
    switch(value){
      case 1:
        tvaValue = 0;
        break;
      case 2:
        tvaValue = 18;
        break;
      case 3:
        tvaValue = 20;
        break;
      case 4:
        tvaValue = 23;
        break;
      case 5:
        tvaValue = 25;
        break;
      default :
        tvaValue = 0;
        break;
    }
    return tvaValue;
  }
  Commande getCommande() {
    Commande commande = Commande(
      id: 0,
      ref: '',
      date_commande: Globals.convertDateFrToEn(dateCmdeCtrl.text),
      montant_recu: 0,
      montant_ht: montantHT,
      montant_ttc: montantTTC,
      remise: montantRemise,
      client: selectedClient.nom,
      email: selectedClient.email,
      etat: 'En attente',
      date_prev_livraison: Globals.convertDateFrToEn(dateLivraisonCtrl.text),
      date_livraison: null,
      date_essaie: Globals.convertDateFrToEn(dateEssaiCtrl.text),
      tva_id: getTvaId(selectedTva),
      etat_id: 1,
      etat_solde_id: 1,
      etat_retrait_id: 1,
      client_id: selectedClient.id,
      user_id: CnxInfo.userID,
    );
    return commande;
  }
  Client? getClient(Commande commande){
    for(int i = 0; i < allClients.length; i++){
      if(commande.client_id == allClients[i].id){
        return selectedClient = allClients[i];
      }
    }
    return null;
  }

  void setData(){
    // Amounts
    montantRemise = widget.cmde!.remise!;
    montantHT = widget.cmde!.montant_ht!;
    montantTTC = widget.cmde!.montant_ttc!;
    tauxRemiseCtrl.text = ((widget.cmde!.remise! * 100) / montantHT).toStringAsFixed(2);
    valeurRemiseCtrl.text = widget.cmde!.remise!.toString();
    selectedTva = getTvaValue(widget.cmde!.tva_id!);
    int netCom = montantHT - int.parse(valeurRemiseCtrl.text);
    valeurTVACtrl.text = (netCom * (selectedTva/100)).round().toString();
    // Other infos
    dateCmdeCtrl.text = Globals.convertDateEnToFr(widget.cmde!.date_commande!)!;
    dateLivraisonCtrl.text = Globals.convertDateEnToFr(widget.cmde!.date_prev_livraison!)!;
    dateEssaiCtrl.text = Globals.convertDateEnToFr(widget.cmde!.date_essaie!)!;
    if (getClient(widget.cmde!) != null) {
      selectedClient = getClient(widget.cmde!)!;
      clientCtrl.text = selectedClient.nom!;
    }
    // lignes commande
    ligneCommandes = widget.ligneCdes!;
  }
  bool isAlreadyAdded(Product product){
    bool isAdded = false;
    for(int i = 0; i < ligneCommandes.length; i++){
      if(product.id == ligneCommandes[i].catalogue_id){
        isAdded = true;
      }
    }
    return isAdded;
  }
  void unSelectAll(){
    for(int i = 0 ; i < checked.length; i++){
      checked[i] = false;
    }
  }

  bool verificationBeforeSubmitting(){
    if(dateCmdeCtrl.text.isEmpty){
      Fluttertoast.showToast(msg: 'renseigner date commande !');
      return false;
    }
    if(clientCtrl.text.isEmpty){
      Fluttertoast.showToast(msg: 'renseigner le client !');
      return false;
    }
    if(ligneCommandes.isEmpty){
      Fluttertoast.showToast(msg: 'Aucun modèle ajouté !');
      return false;
    }
    if(dateLivraisonCtrl.text.isEmpty){
      Fluttertoast.showToast(msg: 'renseigner date livraison !');
      return false;
    }
    if(dateEssaiCtrl.text.isEmpty){
      Fluttertoast.showToast(msg: 'renseigner date essai !');
      return false;
    }
    return true;
  }
  // Retrieve image from Network
  Future<void> getImageFileFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final fileName = url.split('/').last;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(bytes);

    setState(() {
     _imageFile = file;
    });

  }

  /// TRAITEMENTS
  // Montant TTC calculation
  void calculMontantTTC () {
    if (ligneCommandes.isNotEmpty) {
      montantHT = 0;
      for (int i = 0; i < ligneCommandes.length; i++){
        montantHT += ligneCommandes[i].prix!;
      }
      montantTTC = montantHT;
    } else {
      montantTTC = montantHT = 0;
    }

    int netCom = montantHT - int.parse(valeurRemiseCtrl.text);
    if (selectedTva != 0) {
      valeurTVACtrl.text = (netCom * (selectedTva/100)).round().toString();
    }
    else {
      valeurTVACtrl.text = '0';
    }
    montantTTC = netCom + int.parse(valeurTVACtrl.text);
  }
  void initializeAllAmounts() {
    montantRemise = 0;
    montantHT = 0;
    montantTTC = 0;
    tauxRemiseCtrl.text = '0';
    valeurRemiseCtrl.text = '0';
    valeurTVACtrl.text = '0';
    selectedTva = 0;
  }
  // Get all the products and all the categories
  Future<void> getAllProductsAndCategories() async {
    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };
    showProgress(true);
    final response = await http.get(
      Uri.parse(r_product),
      headers: myHeaders,
    );

    if (response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      late CategorieVetement categorieVetement;
      late Product product;

      for(int i = 0; i < responseBody['data']['categorie_vetements'].length; i++){

        categorieVetement = CategorieVetement.fromJson(responseBody['data']['categorie_vetements'][i]);
        allCategories.add(categorieVetement);

        for(int j = 0; j < responseBody['data']['categorie_vetements'][i]['catalogues'].length; j++){
          product = Product.fromJson(responseBody['data']['categorie_vetements'][i]['catalogues'][j]);
          allProducts.add(product);
        }

      }
    } else {
      Fluttertoast.showToast(msg: 'Chargement de données non effectué correctement!');
      Navigator.pop(context);
    }
    // print(allCategories);
    // print(allProducts);
  }
  // Get all client list
  Future<void> getAllClient() async {
    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

    final response = await http.get(
      Uri.parse(r_client),
      headers: myHeaders,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      //allClients.clear();
      late Client client;

      for(int i = 0; i < responseBody['data']['clients'].length; i++){
        client = Client.fromJson(responseBody['data']['clients'][i]);
        allClients.add(client);
      }

      setState(() {foundClients = allClients;});

      // Handle the response
    } else {
      Fluttertoast.showToast(msg: 'Chargement de données non effectué correctement!');
      Navigator.pop(context);
    }
    showProgress(false);
  }

  Future<void> createCommande(Map<String, String> data) async {
    // Here Json data to send

    String bearerToken = 'Bearer ${CnxInfo.token!}';
    var headers = {
      'Accept':'application/json',
      'Content-Type':'application/json',
      'Authorization': bearerToken,
    };

    // create multipart request for POST
    final request = http.MultipartRequest('POST', Uri.parse(r_commande));

    /*// add image file to multipart request
    if(_imageFileAvCompressed != null){
      final image = await http.MultipartFile.fromPath('image_av', _imageFileAvCompressed!.path);
      request.files.add(image);
    }
    if(_imageFileArCompressed != null){
      final image = await http.MultipartFile.fromPath('image_ar', _imageFileArCompressed!.path);
      request.files.add(image);
    }*/

    // add data to multipart request
    request.fields.addAll(data);

    // add headers to multipart request
    request.headers.addAll(headers);

    // Show Loading Progress
    showProgress(true);

    // send multipart request and get response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    // Disable Loading Progress
    showProgress(false);

    // handle response
    if (response.statusCode == 201) {
      final responseData = jsonDecode(responseString);
      print(responseData);
      Fluttertoast.showToast(msg: 'Commande enregistrée avec succès !');
      Navigator.pop(context as BuildContext);
    } else {
      Fluttertoast.showToast(msg: '${response.statusCode} Erreur lors de l\'enregistrement !');
      throw Exception('Failed to upload image');
    }

  }

}

/*List<DropdownMenuItem<CategorieVetement>>? itemsCategories;
  List<DropdownMenuItem<CategorieVetement>> buildDropdownMenuItems(List categorieVetements){
    List<DropdownMenuItem<CategorieVetement>> items = [];
    for(CategorieVetement categorieVetement in categorieVetements){
      items.add(
        DropdownMenuItem(
            child: textMontserrat(categorieVetement.libelle!, 15, Colors.black, TextAlign.start)
        )
      );
    }
    return items;
 }*/
// Move the cursor to the end of the text
//tauxRemiseCtrl.selection = TextSelection.fromPosition(TextPosition(offset: tauxRemiseCtrl.text.length));

//allProducts = widget.productList!;
//allCategories = widget.categoryList!;
//selectedCategorieVetement = allCategories[0];

//runProductFilter(allProducts[0].id.toString());

//allClients = widget.clientList!;
//foundClients = allClients;
//selectedClient = foundClients[0];