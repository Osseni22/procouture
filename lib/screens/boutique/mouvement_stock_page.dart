import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:procouture/widgets/default_app_bar.dart';

import '../../../widgets/custom_text.dart';

class MouvementStock extends StatefulWidget {
  const MouvementStock({Key? key}) : super(key: key);

  @override
  State<MouvementStock> createState() => _MouvementStockState();
}

class _MouvementStockState extends State<MouvementStock> {

  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }
// Step 3
  @override
  dispose() {
    super.dispose();
  }

  TextEditingController dateTimeCtrl = TextEditingController();
  TextEditingController dateTimeCtrl2 = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Mouvement du stock', context, actions: [
        PopupMenuButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          icon: Icon(Icons.more_vert_outlined, color: Colors.black,),
            onSelected: (item) {},
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 1,
                  child: Row(
                    children: [
                      /*Icon(Icons.left, color: Colors.grey.shade400,),
                      SizedBox(width: 5,),*/
                      textOpenSans("Nouvelle entrée", 15, Colors.black, TextAlign.start, fontWeight: FontWeight.w400),
                    ],
                  )
              ),
              PopupMenuItem<int>(
                value: 2,
                  child: Row(
                    children: [
                      /*Icon(Icons.account_balance_rounded, color: Colors.grey.shade400,),
                      SizedBox(width: 5,),*/
                      textOpenSans("Nouvelle sortie", 15, Colors.black, TextAlign.start, fontWeight: FontWeight.w400),
                    ],
                  )
              ),
            ]
        )
      ]),
      backgroundColor: Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isLoading? const LinearProgressIndicator(backgroundColor: Colors.transparent,) : const SizedBox(),
          const SizedBox(height: 8),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textMontserrat("Du", 13, Colors.black, TextAlign.center),
                const SizedBox(width: 10,),
                // Afficher la première date
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                textMontserrat("Au", 13, Colors.black, TextAlign.center),
                const SizedBox(width: 10,),
                // Afficher la deuxième date
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                const SizedBox(width: 15,),
                // Afficher le bouton de recherche
                Container(alignment: Alignment.center,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
          const SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 20,
                  itemBuilder: (context, int index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.0, bottom: 0, left: 6, right: 0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Date et Désignation
                              Container(
                                height: 25,
                                //color: Colors.greenAccent,
                                child: Row(
                                  children: [
                                    textOpenSans('31/12/2023', 13, Colors.black38, TextAlign.left, fontWeight: FontWeight.bold),
                                    const SizedBox(width: 8,),
                                    textOpenSans("Nom de l'article ${index+1}", 14, Colors.black54, TextAlign.left, fontWeight: FontWeight.bold)
                                  ],
                                ),
                              ),

                              /// Motif
                              Container(
                                height: 32,
                                //color: Colors.grey,
                                alignment: Alignment.centerLeft,
                                child: textMontserrat("Motif : Approvisionnements ou Ventes en boutique de l'article ${index+1}", 14, Colors.grey.shade600, TextAlign.left,fontWeight: FontWeight.w600),
                              ),

                              /// Quantité en Mouvement
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:   (index % 2 == 0)? Colors.green.shade200 : Colors.red.shade200,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15))
                                      ),
                                      child: textMontserrat(
                                          (index % 2 == 0)? 'Entrée : ${index+1}' : 'Sortie : ${index+1}', 13, Colors.black, TextAlign.right, fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }
}
