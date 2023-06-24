import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:procouture/components/message_box.dart';
import 'package:procouture/screens/confection/employe/employe_menu_page.dart';
import 'package:procouture/screens/confection/employe/employe_save_page.dart';
import 'package:procouture/screens/confection/fournisseur/achat_page.dart';
import 'package:procouture/screens/confection/fournisseur/fournisseur_save_page.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart'as http;
import 'package:procouture/widgets/default_app_bar.dart';

import '../../../utils/globals/global_var.dart';

class FournisseurPage extends StatefulWidget {
  const FournisseurPage({super.key});

  @override
  State<FournisseurPage> createState() => _FournisseurPageState();
}

class _FournisseurPageState extends State<FournisseurPage> {

  bool searchBoolean = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: myDefaultAppBar('Liste des Fournisseur', context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          Expanded(
              child: Container(

                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 23, right: 23, top: 10, bottom: 0),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                if(await msgBoxYesNo('Confirmation ', 'Supprimer ce fournisseur ?', context)){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  print("Fournisseur ${index+1} Supprimé");
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  print("Fournisseur ${index+1} pas supprimé");
                                };
                              },
                              icon: CupertinoIcons.delete,
                              label: 'Supprimer',
                              backgroundColor: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(15),
                            )
                          ],
                        ),
                        child: GestureDetector(
                          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) => AchatPage()));},
                          child: Container(
                            height: 83,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              /*boxShadow: [
                                BoxShadow(
                                  color: Color(0xff040039).withOpacity(.10),
                                  blurRadius: 10,
                                )
                              ]*/
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 23,
                                    backgroundColor: Colors.orange,
                                    child: textLato("Fournisseur $index".substring(0,1), 22, Colors.black, TextAlign.center),
                                  ),
                                  const SizedBox(width: 20,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textMontserrat("Fournisseur ${index+1}", 19, Colors.black, TextAlign.left),
                                        const SizedBox(height: 2,),
                                        textWorkSans('00 11 22 33 44 55', 14, Colors.grey, TextAlign.left),
                                        const SizedBox(height: 2,),
                                        textWorkSans("Ville du fournisseur ${index+1}", 14, Colors.grey, TextAlign.left)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              )
          ),
          Container(
              alignment: Alignment.centerRight,
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: textRaleway('10 Fournisseurs au total', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7.0,
        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => FournisseurSavePage()));},
        isExtended: true,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget searchTextField() {
    return TextField(
      autofocus: true, //Display the keyboard when TextField is displayed
      cursorColor: Colors.green,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Montserrat'
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Rechercher un fournisseur',
          hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey, fontSize: 20)
      ),
    );
  }

  void startLoading(){
    setState(() {
      isLoading = true;
    });
  }
  void endLoading(){
    setState(() {
      isLoading = false;
    });
  }

}
