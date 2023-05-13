import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:procouture/widgets/default_box_shadow.dart';

import '../transaction/depenses_commande_page.dart';
import '../transaction/reglement_page.dart';

class ClientCommandePage extends StatefulWidget {
  const ClientCommandePage({Key? key}) : super(key: key);

  @override
  State<ClientCommandePage> createState() => _ClientCommandePageState();
}

class _ClientCommandePageState extends State<ClientCommandePage> {

  TextEditingController dateTimeCtrl = TextEditingController();
  TextEditingController dateTimeCtrl2 = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');

  List<String> itemsEtatCmde = [
    'En Attente',
    'Terminée',
    'Annulée'
  ];
  String etatCmdeValue = 'En Attente';

  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Commandes', context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isLoading? const LinearProgressIndicator(backgroundColor: Colors.transparent,) : const SizedBox(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 120,
              //color: Colors.blue,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                                  hintText: 'Date d',
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

          const SizedBox(height: 15),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, int index) => GestureDetector(
                      onTap: (){ print('OK'); },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
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
                                              child: textOpenSans('Soldée', 13, Colors.red, TextAlign.center),
                                            ),
                                          ),
                                          Container(
                                            width: 160,
                                            child:  textOpenSans('Cmde N°${index+1}', 16, Colors.black, TextAlign.center),
                                          ),
                                          Container(
                                            width: 80,
                                            alignment: AlignmentDirectional.centerEnd,
                                            child: Visibility(
                                              visible: true,
                                              child: textRaleway('Ref${index+1}', 12, Colors.black26, TextAlign.right),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Afficher le nom du client
                                      /*Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          textOpenSans('Client ${index+1}', 16, Colors.green, TextAlign.center),
                                        ],
                                      ),*/
                                      // Afficher les dates
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          textOpenSans('Date Cmde : ', 11, Colors.black, TextAlign.center),
                                          textOpenSans('31/12/2023', 13, Colors.black45, TextAlign.center,fontWeight: FontWeight.bold),
                                          textOpenSans('Date Livr. : ', 11, Colors.black, TextAlign.center),
                                          textOpenSans('31/12/2023', 13, Colors.black45, TextAlign.center,fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                      // Montant TTC
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Montant TTC : ', 13, Colors.black, TextAlign.center)),
                                          const SizedBox(width: 4,),
                                          Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      // Montant Regle
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Montant réglé : ', 13, Colors.black, TextAlign.center)),
                                          const SizedBox(width: 4,),
                                          Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      // Montant Restant
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Montant restant : ', 13, Colors.black, TextAlign.center)),
                                          const SizedBox(width: 4,),
                                          Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
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
                                        onTap: (){ /*Navigator.push(context, MaterialPageRoute(builder: (_) => ReglementPage()));*/},
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
                                                      FaIcon(FontAwesomeIcons.blackTie, color: Colors.grey,),
                                                      SizedBox(
                                                        // sized box with width 10
                                                        width: 10,
                                                      ),
                                                      textOpenSans("Modèles commandes",16,Colors.black,TextAlign.left)
                                                    ],
                                                  ),
                                                ),
                                                // popupmenu item 2
                                                PopupMenuItem(
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
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  // row has two child icon and text
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.my_library_books_rounded, color: Colors.grey),
                                                      SizedBox(
                                                        // sized box with width 10
                                                        width: 10,
                                                      ),
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
                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => DepenseCommandePage()));
                                                  // _showDialog(context);
                                                } else if (value == 3) {

                                                  setState(() {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DepenseCommandePage()));
                                                  });

                                                } else if (value == 4) {
                                                  // _showDialog(context);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
              )
          ),
          Container(
            height: 15,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            alignment: Alignment.centerRight,
            child: textRaleway('Client : Osseni Abdel Aziz', 10, Colors.black, TextAlign.right),
          )
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
