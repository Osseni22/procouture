import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/screens/confection/commande/commande_details_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/models/Client.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/widgets/default_box_shadow.dart';

import '../../../models/Commande.dart';
import '../../../models/LigneCommande.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';
import '../../models/Atelier.dart';

class AdminCommandePage extends StatefulWidget {
  final Atelier atelier;
  const AdminCommandePage({Key? key, required this.atelier,}) : super(key: key);

  @override
  State<AdminCommandePage> createState() => _AdminCommandePageState();
}

class _AdminCommandePageState extends State<AdminCommandePage> {

  TextEditingController dateTimeCtrl = TextEditingController();
  TextEditingController dateTimeCtrl2 = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');

  bool showFilter = false;
  bool isOK = false;

  List<String> itemsEtatCmde = [
    'En Attente',
    'Valide',
    'Annulée',
    'En cours'
  ];

  String etatCmdeValue = 'En Attente';
  bool isLoading = false;

  // Get all the commandes in a list
  List<Commande> allCommandes = [];
  List<Commande> allClientCommandes = [];

  // Get all lignes commandes in a list
  List<LigneCommande> allLigneCommandes = [];


  @override
  void initState() {
    getCommandesList();
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
                      onTap: () {
                        CnxInfo.symboleMonnaie = widget.atelier.monnaie!.libelle!;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_)=> CommandeDetailsPage(commande: allCommandes[index], ligneCmdes: getLigneCommandes(allCommandes[index].id!),)
                            )
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        height: 160,
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
                                            child:  textOpenSans("Cmde ${allCommandes[index].id}", 16, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          textOpenSans('Date Cmde : ', 11, Colors.black, TextAlign.center),
                                          textOpenSans("${Globals.convertDateEnToFr(allCommandes[index].date_commande!)}", 13, Colors.black45, TextAlign.center,fontWeight: FontWeight.bold),
                                          SizedBox(width: 20,),
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
                                          Container(width: 100,alignment: Alignment.centerLeft, child: textOpenSans("${NumberFormat('#,###', 'fr_FR').format(allCommandes[index].montant_ttc)} ${widget.atelier.monnaie!.symbole}", 15, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      // Montant Regle
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(width: 120,alignment: Alignment.centerRight, child: textOpenSans('Montant réglé : ', 13, Colors.black, TextAlign.center)),
                                          const SizedBox(width: 4,),
                                          Container(width: 100,alignment: Alignment.centerLeft, child: textOpenSans("${NumberFormat('#,###', 'fr_FR').format(allCommandes[index].montant_recu)} ${widget.atelier.monnaie!.symbole}", 15, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      // Montant Restant
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(width: 120,alignment: Alignment.centerRight,child: textOpenSans('Montant restant : ', 13, Colors.black, TextAlign.center)),
                                          const SizedBox(width: 4,),
                                          Container(width: 100, alignment: Alignment.centerLeft, child: textOpenSans("${NumberFormat('#,###', 'fr_FR').format(allCommandes[index].montant_ttc! - allCommandes[index].montant_recu!)} ${widget.atelier.monnaie!.symbole}", 15, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
              ) : const Center(child: Text('Aucune commande pour ce client'),)
          ),
          const SizedBox(height: 15),
          /*Container(
            height: 25,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 10),
            child: textMontserrat("Client: ${widget.client.nom}", 14, Colors.black, TextAlign.end),
          )*/
        ],
      ),
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

  List<Commande> getClientCommandes(Client client){
    List<Commande> cmdes = [];
    for(int i = 0; i < allCommandes.length; i++){
      if(allCommandes[i].client_id == client.id){
        cmdes.add(allCommandes[i]);
      }
    }
    return cmdes;
  }

  Future<void> getCommandesList() async {

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(AdminRoutes.r_getCommandesUrl(widget.atelier.id!)),
      headers: Globals.apiHeaders,
    );
    loadingProgress(false);

    if(response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      allCommandes.clear();
      allLigneCommandes.clear();

      late Commande commande;
      late LigneCommande ligneCommande;

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
    //allClientCommandes = getClientCommandes(widget.client);
  }
}
