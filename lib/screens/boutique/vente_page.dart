import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procouture/screens/boutique/reglement_vente_page.dart';
import 'package:procouture/screens/confection/transaction/depenses_commande_page.dart';
import 'package:procouture/screens/confection/transaction/reglement_page.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:procouture/widgets/default_box_shadow.dart';

class VentePage extends StatefulWidget {
  const VentePage({Key? key}) : super(key: key);

  @override
  State<VentePage> createState() => _VentePageState();
}

class _VentePageState extends State<VentePage> {


  TextEditingController dateTimeCtrl = TextEditingController();
  TextEditingController dateTimeCtrl2 = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');
  //final format2 = DateFormat('dd-MM-yyyy');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Ventes', context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isLoading? const LinearProgressIndicator(backgroundColor: Colors.transparent,) : const SizedBox(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Afficher la première date
                    Container(
                      alignment: Alignment.center,
                      height: 40,
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
                      height: 40,
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
                      height: 40,
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
                          borderRadius: BorderRadius.circular(15),
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
                                      // Afficher Etat Solde, N°Vente, Etat Cmde Rapide
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
                                            child:  textOpenSans('Vente N°${index+1}', 16, Colors.black, TextAlign.center),
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          textOpenSans('Client ${index+1}', 16, Colors.green, TextAlign.center),
                                        ],
                                      ),
                                      // Afficher les dates
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          textOpenSans('Date vente : ', 13, Colors.black, TextAlign.center),
                                          textOpenSans('31/12/2023', 14, Colors.black45, TextAlign.center,fontWeight: FontWeight.bold),
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
                              /// Bouton d'actions
                              Container(
                                height: 50,
                                //color: Colors.blue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: GestureDetector(
                                        onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => ReglementVentePage()));},
                                        child: Container(
                                          width: 170,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          //color: Colors.blueAccent,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              textOpenSans('Règlement', 15, Colors.black, TextAlign.start),
                                              Icon(Icons.payments, color: Colors.black,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: Container(
                                        width: 70,
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
                                        width: 70,
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
          )
        ],
      ),
      floatingActionButton: const FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 10,
        onPressed: null,
        child: Icon(CupertinoIcons.add, color: Colors.black,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
