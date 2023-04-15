import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:procouture/models/Client.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../models/CategorieVetement.dart';
import '../../../models/Product.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';

class CommandeSavePage2 extends StatefulWidget {
  final String pageMode; List<Client>? clientList; List<CategorieVetement>? categoryList; List<Product>? productList;
  CommandeSavePage2({Key? key,
    required this.pageMode, required this.clientList, required this.categoryList,required this.productList,
  }) : super(key: key);

  @override
  State<CommandeSavePage2> createState() => _CommandeSavePage2State();
}

class _CommandeSavePage2State extends State<CommandeSavePage2> {

  bool isLoading = false;
  double fHeight = 40;
  int nombreModele = 4;

  late int currentIndex;
  PersistentBottomSheetController? bscontroller ;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var pageIndex = 0;
  List<Widget> cmdePages = <Widget>[];

  /// CLIENTS
  List<Client> allClients = [];
  List<Client> foundClients = [];
  late Client selectedClient;

  /// PRODUCTS ET CATEGORIES
  // Categories
  List<CategorieVetement> allCategories = [];
  late CategorieVetement selectedCategorieVetement;
  int selectedCatVetIndex = 0;


  // Products
  List<Product> allProducts = [];
  List<Product> productsByCategorie = [];
  late Product selectedProduct;
  List<bool> checked = [];

  /// DATE CONTROLLERS
  TextEditingController dateCmdeCtrl = TextEditingController();
  TextEditingController dateLivraisonCtrl = TextEditingController();
  TextEditingController dateEssaiCtrl = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');

  TextEditingController clientCtrl = TextEditingController();

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

  @override
  void initState() {
    // Load all fundamentals
    allProducts = widget.productList!;

    allCategories = widget.categoryList!;
    selectedCategorieVetement = allCategories[0];

    runProductFilter(allProducts[0].id.toString());

    allClients = widget.clientList!;
    foundClients = allClients;
    selectedClient = foundClients[0];

    // Initialize the checked list with all false values
    checked = List<bool>.filled(productsByCategorie.length, false);

    // Init all page elements
    initialiserElementsFenetre();

    /*// fill dropdown
    itemsCategories = buildDropdownMenuItems(allCategories);
    //print(itemsCategories);
    // selected by default
    selectedCategorieVetement = itemsCategories![0].value!;*/

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar('Fiche Commande', context,
          actions: [
            IconButton(onPressed: (){
                setState(() {
                  pageIndex = 0;
                });
              }, icon: Icon(Icons.refresh_outlined, color: Colors.black,)
            )
          ]
      ),
      body: cmdePages[pageIndex],
    );
  }

  /// PAGE INFO COMMANDE
  Widget detailCmde(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Loading progress
        isLoading? const LinearProgressIndicator(backgroundColor: Colors.transparent) : const SizedBox(),
        SizedBox(height: 3,),
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
                    height: fHeight + 5,
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
                      height: fHeight + 5,
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
            onTap: (){
              setState(() {
                pageIndex = 1;
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
          child: nombreModele > 0 ? buildModeleAjoutes() : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.03),
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
                    height: fHeight,
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
                    height: fHeight,
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
                //color: Colors.white,
                //border: Border.all(color: Colors.grey.shade400)
              //boxShadow: [kDefaultBoxShadow3]
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
                         child: textMontserrat('25 000 FCFA', 18, Colors.black, TextAlign.end,fontWeight: FontWeight.bold),
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
                         child: textMontserrat('250 000 FCFA', 18, Colors.black, TextAlign.end,fontWeight: FontWeight.bold),
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
                         child: textMontserrat('250 000 FCFA', 18, Colors.black, TextAlign.end,fontWeight: FontWeight.bold),
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
                child: Container(
                  height: fHeight + 10,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200)
                  ),
                  child: textMontserrat('TVA / Remise', 13, Colors.black, TextAlign.center),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: fHeight + 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kProcouture_green
                    ),
                    child: textMontserrat('Valider la commande', 13, Colors.white, TextAlign.center, fontWeight: FontWeight.w500),
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
  Widget editModeleInfo(){
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // La source de selection du modèle
              textRaleway('Source du modèle', 13, Colors.black, TextAlign.center),
              SizedBox(height: 10),
              // Image du modèle
              Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade400),
                    image: DecorationImage(
                        image: _imageFile == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFile!.path)),
                        fit: BoxFit.cover
                    )
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 47,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 70,
                      alignment: Alignment.center,
                      child: textMontserrat('Choisir depuis', 13, Colors.black, TextAlign.left),
                    ),
                    Container(
                      height: 45,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber,
                      ),
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
                                    FaIcon(FontAwesomeIcons.blackTie, color: Colors.blueGrey,),
                                    SizedBox(width: 10,),
                                    textOpenSans("Catalogue",16,Colors.blueGrey,TextAlign.left)
                                  ],
                                ),
                              ),
                              // popupmenu item 2
                              PopupMenuItem(
                                value: 2,
                                // row has two child icon and text
                                child: Row(
                                  children: [
                                    Icon(Icons.camera, color: Colors.blueGrey),
                                    SizedBox(width: 10,),
                                    textOpenSans("Camera",16,Colors.blueGrey,TextAlign.left)
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                // row has two child icon and text
                                child: Row(
                                  children: [
                                    Icon(Icons.image,color: Colors.blueGrey),
                                    SizedBox(width: 10,),
                                    textOpenSans("Galerie",16,Colors.blueGrey,TextAlign.left)
                                  ],
                                ),
                              ),
                            ],
                            elevation: 10,
                            // on selected we show the dialog box
                            onSelected: (value) async {
                              // if value 1 show dialog
                              if (value == 1) {
                                //runProductFilter(allProducts[0].id.toString());
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (ctx) => selectModele(),
                                  shape: const RoundedRectangleBorder( // <-- SEE HERE
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14.0),
                                    ),
                                  ),
                                );
                                // if value 2 show dialog
                              } else if (value == 2) {
                                // code
                                // _showDialog(context);
                              } else if (value == 3) {
                                //
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Champs de saisie
              Container(
                height: 303,
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
                      child: TextField(
                        //controller: designationCtrl,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Libellé',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                      ),
                      child: TextField(
                        //controller: prixHtCtrl,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Prix HT',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                        ),
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
                          Expanded(
                            child: TextField(
                              //controller: prixHtCtrl,
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Quantité',
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
                                    // Code
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
                                    // Code
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
                      ),
                      child: TextField(
                        //controller: prixHtCtrl,
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Description',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: double.infinity,
                  padding:  EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 10)
                        )
                      ]
                  ),
                  child: textMontserrat('Valider', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.w500,),
                ),
              )
            ],
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
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: productsByCategorie.length,
                        itemBuilder: (context, int index) => Container(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                selectedProduct = productsByCategorie[index];
                                pageIndex = 1;
                                Navigator.pop;
                              });
                            },
                            child: ListTile(
                              title: textOpenSans(productsByCategorie[index].libelle!, 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                              subtitle: textMontserrat(productsByCategorie[index].prix_ht.toString(), 12, Colors.black, TextAlign.start),
                            ),
                          ),
                        ),
                      )
                    ),
                  )
                ),
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: (){},
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

  /// INITIALISER TOUS LES ELEMENTS DE LA FENETRE
  void initialiserElementsFenetre(){
    cmdePages.add(detailCmde());
    cmdePages.add(editModeleInfo());
    //cmdePages.add(selectModele());
    pageIndex = 0;
  }

  /// ZONE D'AFFICHAGE DES MODELES AJOUTES
  Widget buildModeleAjoutes(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: nombreModele,
        itemBuilder: (context, int index) => Padding(
          padding: EdgeInsets.only(bottom: 5),
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
                                  textMontserrat('${index+1}', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
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
                                        child: textMontserrat('Libellé du modèle ${index + 1}', 14, Colors.black, TextAlign.center,),
                                    ),
                                    textMontserrat('200 000 FCFA', 15, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                                  ],
                                ),
                              )
                          ),
                          // Afficher le bouton de suppression du modèle
                          Container(
                            width: 50,
                            child: IconButton(
                              onPressed: (){},
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
                      pageIndex = 2;
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
                        height: fHeight + 10,
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

  /// TRAITEMENTS
  // Get all the products and all the categories
  Future<void> getAllProductsAndCategories() async {
    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

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
    }
    print(allCategories);
    print(allProducts);
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
