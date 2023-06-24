import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procouture/screens/confection/commande/commande_details_page.dart';
import 'package:procouture/screens/confection/transaction/depenses_commande_page.dart';
import 'package:procouture/screens/confection/transaction/reglement_page.dart';
import 'package:procouture/screens/confection/commande/commande_save_page.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/models/Client.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/widgets/default_box_shadow.dart';

import '../../../components/message_box.dart';
import '../../../models/CategorieVetement.dart';
import '../../../models/Commande.dart';
import '../../../models/ConfigData.dart';
import '../../../models/LigneCommande.dart';
import '../../../models/Product.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';

class CommandePage extends StatefulWidget {
  const CommandePage({Key? key}) : super(key: key);

  @override
  State<CommandePage> createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {

  TextEditingController dateTimeCtrl = TextEditingController();
  TextEditingController dateTimeCtrl2 = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');

  bool showFilter = false;
  bool isOK = false;

  List<String> itemsEtatCmde = [
    'En Attente',
    'Terminée',
    'Annulée'
  ];

  String etatCmdeValue = 'En Attente';
  bool isLoading = false;

  // Get all the commandes in a list
  List<Commande> allCommandes = [];

  // Get all lignes commandes in a list
  List<LigneCommande> allLigneCommandes = [];

  /// Load informations before going to save page
  // Get all client liste
  List<Client> allClients = [];
  // Categories
  List<CategorieVetement> allCategories = [];
  // Products
  List<Product> allProducts = [];
  // If all data are loaded correctly
  bool isProductOk = false;
  bool isClientOk = false;

  @override
  void initState() {
    getCommandesList();
    getAllCmdeElements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Commandes', context, actions: [
        IconButton(onPressed: (){
          setState(() {
            showFilter = !showFilter;
          });
        }, icon: !showFilter? Icon(Icons.filter_alt, color: Colors.black,) : Icon(Icons.filter_alt_off,color: Colors.black,))
      ]),
      body: isLoading? const LinearProgressIndicator(backgroundColor: Colors.transparent,) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //isLoading? const LinearProgressIndicator(backgroundColor: Colors.transparent,) : const SizedBox(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedContainer(
              curve: Curves.easeInQuad,
              duration: Duration(milliseconds: 500),
              height: showFilter? 120 : 0,
              //color: Colors.blue,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [kDefaultBoxShadow]
              ),
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// INFORMATIONS DE FILTRAGE
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 40,
                          //color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Afficher la première date
                              Container(
                                alignment: Alignment.center,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  //border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child: DateTimeField(
                                  resetIcon: null,
                                  style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                  format: format,
                                  controller: dateTimeCtrl,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Date début',
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
                              ),
                              const SizedBox(width: 10,),
                              // Afficher la deuxième date
                              Container(
                                alignment: Alignment.center,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  //border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child: DateTimeField(
                                  resetIcon: null,
                                  style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                  format: format,
                                  controller: dateTimeCtrl2,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Date fin',
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
                              ),
                              const SizedBox(width: 10,),

                              // Afficher le bouton de recherche
                              Container(alignment: Alignment.center,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  //border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(CupertinoIcons.search, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            //border: Border.all(color: Colors.grey.withOpacity(0.5))
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: textRaleway("Choisir l'état de la commande",16,Colors.grey,TextAlign.center),
                            value: etatCmdeValue,
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            items: itemsEtatCmde.map((String itemsValue) {
                              return DropdownMenuItem(
                                value: itemsValue,
                                child: Center(
                                    child: textRaleway(itemsValue,16,Colors.black, TextAlign.center)
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                etatCmdeValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          /// AFFICHAGE DES COMMANDES
          const SizedBox(height: 15),
          Expanded(
              child: allCommandes.isNotEmpty?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: allCommandes.length,
                  itemBuilder: (context, int index) => GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CommandeDetailsPage(commande: allCommandes[index], ligneCmdes: getLigneCommandes(allCommandes[index].id!),)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      height: 230,
                      decoration: BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        //boxShadow: [kDefaultBoxShadow]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Afficher Etat Solde, N°Cmde, Etat Cmde Rapide
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 80,
                                          alignment: Alignment.centerLeft,
                                          child: Visibility(
                                            visible: true,
                                            child: textRaleway(allCommandes[index].etat!, 12, Colors.red, TextAlign.center),
                                          ),
                                        ),
                                        Container(
                                          width: 160,
                                          child:  textOpenSans("Cmde ${allCommandes[index].id}", 16, Colors.black, TextAlign.center),
                                        ),
                                        Container(
                                          width: 80,
                                          alignment: AlignmentDirectional.centerEnd,
                                          child: Visibility(
                                            visible: true,
                                            child: textWorkSans(allCommandes[index].ref!, 12, Colors.black26, TextAlign.right),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Afficher le nom du client
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        textOpenSans(allCommandes[index].client!.toUpperCase(), 16, Colors.green, TextAlign.center),
                                      ],
                                    ),
                                    // Afficher les dates
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        textOpenSans('Date Cmde : ', 11, Colors.black, TextAlign.center),
                                        textOpenSans("${Globals.convertDateEnToFr(allCommandes[index].date_commande!)}", 13, Colors.black45, TextAlign.center,fontWeight: FontWeight.bold),
                                        textOpenSans('Date Livr. : ', 11, Colors.black, TextAlign.center),
                                        textOpenSans("${Globals.convertDateEnToFr(allCommandes[index].date_prev_livraison!)}", 13, Colors.black45, TextAlign.center,fontWeight: FontWeight.bold),
                                      ],
                                    ),
                                    // Montant TTC
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(width: 120,alignment: Alignment.centerRight, child: textOpenSans('Montant TTC : ', 13, Colors.black, TextAlign.center)),
                                        const SizedBox(width: 4,),
                                        Container(width: 100,alignment: Alignment.centerLeft, child: textOpenSans("${NumberFormat('#,###', 'fr_FR').format(allCommandes[index].montant_ttc)} ${CnxInfo.symboleMonnaie}", 15, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    // Montant Regle
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(width: 120,alignment: Alignment.centerRight, child: textOpenSans('Montant réglé : ', 13, Colors.black, TextAlign.center)),
                                        const SizedBox(width: 4,),
                                        Container(width: 100,alignment: Alignment.centerLeft, child: textOpenSans("${NumberFormat('#,###', 'fr_FR').format(allCommandes[index].montant_recu)} ${CnxInfo.symboleMonnaie}", 15, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    // Montant Restant
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(width: 120,alignment: Alignment.centerRight,child: textOpenSans('Montant restant : ', 13, Colors.black, TextAlign.center)),
                                        const SizedBox(width: 4,),
                                        Container(width: 100, alignment: Alignment.centerLeft, child: textOpenSans("${NumberFormat('#,###', 'fr_FR').format(allCommandes[index].montant_ttc! - allCommandes[index].montant_recu!)} ${CnxInfo.symboleMonnaie}", 15, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            // Divider
                            Divider(height: 7,),
                            // Bouton d'actions
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(context, MaterialPageRoute(builder: (_) => ReglementPage(commande : allCommandes[index])));
                                        getCommandesList();
                                        getAllCmdeElements();
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        //color: Colors.blueAccent,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            textOpenSans('Règlement', 12, Colors.black, TextAlign.start),
                                            Icon(Icons.payments, color: Colors.black,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: GestureDetector(
                                      onTap:() async {
                                        await Navigator.push(context, MaterialPageRoute(builder: (context) => CommandeSavePage(pageMode: 'M', cmde: allCommandes[index], ligneCdes: getLigneCommandes(allCommandes[index].id!),)));
                                        getCommandesList();
                                        getAllCmdeElements();
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        //color: Colors.blueAccent,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.edit_note, color: Colors.black,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Container(
                                      //alignment: Alignment.center,
                                      width: 60,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(30)
                                      ),
                                      //color: Colors.blueAccent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          //Icon(Icons.more_vert_outlined, color: Colors.black,)
                                          PopupMenuButton<int>(
                                            iconSize: 17,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0),
                                                ),
                                            ),
                                            itemBuilder: (context) => [
                                              // popupmenu item 1
                                              PopupMenuItem(
                                                value: 1,
                                                // row has two child icon and text.
                                                child: Row(
                                                  children: [
                                                    //FaIcon(FontAwesomeIcons.blackTie, color: Colors.grey,),
                                                    Icon(Icons.check_circle, color: Colors.grey,),
                                                    SizedBox(
                                                      // sized box with width 10
                                                      width: 10,
                                                    ),
                                                    textOpenSans("Retrait de la commande",16,Colors.black,TextAlign.left)
                                                  ],
                                                ),
                                              ),
                                              // popupmenu item 2
                                              /*PopupMenuItem(
                                                value: 2,
                                                // row has two child icon and text
                                                child: Row(
                                                  children: [
                                                    Icon(CupertinoIcons.staroflife_fill, color: Colors.grey),
                                                    SizedBox(
                                                      // sized box with width 10
                                                      width: 10,
                                                    ),
                                                    textOpenSans("Matières déposées",16,Colors.black,TextAlign.left)
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 2,
                                                // row has two child icon and text
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.account_balance_wallet_rounded,color: Colors.grey),
                                                    SizedBox(
                                                      // sized box with width 10
                                                      width: 10,
                                                    ),
                                                    textOpenSans("Dépenses",16,Colors.black,TextAlign.left)
                                                  ],
                                                ),
                                              ),*/
                                              PopupMenuItem(
                                                value: 2,
                                                // row has two child icon and text
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.my_library_books_rounded, color: Colors.grey),
                                                    SizedBox(width: 10,),
                                                    textOpenSans("Facture",16,Colors.black,TextAlign.left)
                                                  ],
                                                ),
                                              ),
                                            ],
                                            elevation: 10,
                                            // on selected we show the dialog box
                                            onSelected: (value) {
                                              // if value 1 show dialog
                                              if (value == 1) {
                                                //Navigator.push(context, MaterialPageRoute(builder: (_)=>DepenseCommandePage()));
                                                // if value 2 show dialog
                                              } else if (value == 2) {
                                                //Navigator.push(context, MaterialPageRoute(builder: (_) => DepenseCommandePage()));
                                               // _showDialog(context);
                                              } else if (value == 3) {

                                                setState(() {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DepenseCommandePage()));
                                                });

                                              } else if (value == 4) {
                                               /**/
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (await msgBoxYesNo('Annulation', 'Opération irréversible, \nAnnuler cette commande (${allCommandes[index].ref!}) ?', context)) {
                                          cancelCommande(allCommandes[index].id!);
                                          getCommandesList();
                                          getAllCmdeElements();
                                        }
                                      },
                                      child: Container(
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.red[400],
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        //color: Colors.blueAccent,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.close, color: Colors.white,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ),
              ) : const Center(child: Text('Aucune Commande enregistrée'),)
          ),
          const SizedBox(height: 15),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CommandeSavePage(pageMode: 'A',)));
          getCommandesList();
          getAllCmdeElements();
        },
        child: Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void loadingProgress(bool value){
    if(value){
      setState(() { isLoading = true;});
    } else {
      setState(() { isLoading = false;});
    }
  }
  
  List<LigneCommande> getLigneCommandes(int cmdeId){
    List<LigneCommande> ligneCommandes = [];
    for(int i = 0; i < allLigneCommandes.length; i++){
      if(allLigneCommandes[i].commande_id == cmdeId){
        ligneCommandes.add(allLigneCommandes[i]);
      }
    }
    return ligneCommandes;
  }

  Future<void> getCommandesList() async {

    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_commande),
      headers: myHeaders,
    );
    loadingProgress(false);

    if(response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      allCommandes.clear();
      allLigneCommandes.clear();

      late Commande commande;
      late LigneCommande ligneCommande;
      //print("NOMBRES COMMANDES ${responseBody['data']['commandes'].length}");

      for(int i = 0; i < responseBody['data']['commandes'].length; i++) { // Get all commandes

        commande = Commande.fromJson(responseBody['data']['commandes'][i]);
        allCommandes.add(commande);
        for(int j = 0; j < responseBody['data']['commandes'][i]['ligne_commandes'].length; j++){ // Get all ligne commandes
          ligneCommande = LigneCommande.fromJson(responseBody['data']['commandes'][i]['ligne_commandes'][j]);
          allLigneCommandes.add(ligneCommande);
        }
      }
    }
    allCommandes.sort((a, b) => b.id!.compareTo(a.id!));
  }

  // Get all the elements of saving order
  Future<void> getAllCmdeElements() async {
    isOK = false;
    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };
    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_commandeInfos),
      headers: myHeaders,
    );
    loadingProgress(false);
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {

      isOK = true;

      late CategorieVetement categorieVetement;
      late Product product;
      late ModeReglement modeReglement;
      late Tva tva;
      late Client client;

      /// GET PRODUCTS AND CATEGORIES
      CmdeVar.allCategories.clear();
      CmdeVar.allProducts.clear();
      for(int i = 0; i < responseBody['data']['categorie_vetements'].length; i++){
        categorieVetement = CategorieVetement.fromJson(responseBody['data']['categorie_vetements'][i]);
        CmdeVar.allCategories.add(categorieVetement);

        for(int j = 0; j < responseBody['data']['categorie_vetements'][i]['catalogues'].length; j++){
          product = Product.fromJson(responseBody['data']['categorie_vetements'][i]['catalogues'][j]);
          CmdeVar.allProducts.add(product);
        }
      }

      /// GET CLIENT LIST
      CmdeVar.allClients.clear();
      for(int i = 0; i < responseBody['data']['clients'].length; i++){
        client = Client.fromJson(responseBody['data']['clients'][i]);
        CmdeVar.allClients.add(client);
      }
      CmdeVar.foundClients = CmdeVar.allClients;
      CmdeVar.selectedClient = CmdeVar.foundClients[0];

      /// GET MODE REGLEMENT LIST
      CmdeVar.allModeReglements.clear();
      for(int i = 0; i < responseBody['data']['mode_reglements'].length; i++){
        modeReglement = ModeReglement.fromJson(responseBody['data']['mode_reglements'][i]);
        CmdeVar.allModeReglements.add(modeReglement);
      }

      /// GET TVA LIST
      CmdeVar.allTauxTva.clear();
      for(int i = 0; i < responseBody['data']['tva'].length; i++){
        tva = Tva.fromJson(responseBody['data']['tva'][i]);
        CmdeVar.allTauxTva.add(tva);
      }
      CmdeVar.selectedTva = CmdeVar.allTauxTva[0];

    } else {
      isOK = false;
      Fluttertoast.showToast(msg: '${responseBody['messages']}');
      Navigator.pop(context);
    }

  }


  Future<void> cancelCommande(int commande_id) async {

    String bearerToken = 'Bearer ${CnxInfo.token!}';
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
    };

    var request = http.MultipartRequest('PUT', Uri.parse("$r_commande/${commande_id.toString()}/cancel"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: 'Commande annulée avec succès !');
    } else {
      final responseData = jsonDecode(responseString);
      Fluttertoast.showToast(msg: '${response.statusCode} Erreur lors de l\'annulation !');
    }
  }

}

//commandes = (responseBody as List).map((data) => Commande.fromJson(data)).toList();