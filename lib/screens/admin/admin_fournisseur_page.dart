import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/models/Fournisseur.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart'as http;

import '../../../utils/globals/global_var.dart';
import '../../models/Atelier.dart';


class AdminFournisseurPage extends StatefulWidget {
  final Atelier atelier;
  const AdminFournisseurPage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminFournisseurPage> createState() => _AdminFournisseurPageState();
}

class _AdminFournisseurPageState extends State<AdminFournisseurPage> {

  bool searchBoolean = false;
  bool isLoading = false;
  double fournisseurInfoTextSize = 14;

  List<Employe> allFournisseurs = [];
  List<Employe> foundFournisseurs = [];
  Employe? selectedFournisseur;

  @override
  void initState() {
    getAllFournisseurs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: !searchBoolean ? textMontserrat('Fournisseurs', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.w500) : searchTextField(),
        centerTitle: true,
        actions: [
          !searchBoolean ?
          IconButton(onPressed: (){
            setState(() {
              searchBoolean = true;
            });
          },
            icon: const Icon(Icons.search), color: Colors.black,
          ) :
          IconButton(onPressed: (){
            setState(() {
              searchBoolean = false;
              runFilter('');
            });
          },
            icon: Icon(Icons.close), color: Colors.black,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          Expanded(
              child: Container(
                //padding: EdgeInsets.only(left: 13, right: 13, top: 10),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: foundFournisseurs.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 23, right: 23, top: 10),
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: InkWell(
                          splashColor: Colors.orange.withOpacity(0.1),
                          onTap: (){
                            selectedFournisseur = foundFournisseurs[index];
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (ctx) => showClientInfo(selectedFournisseur!),
                              shape: const RoundedRectangleBorder( // <-- SEE HERE
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: textLato(foundFournisseurs[index].nom!.toUpperCase().substring(0,1), 18, Colors.black, TextAlign.center),
                            ),
                            title: textMontserrat('${foundFournisseurs[index].nom}', 18, Colors.black, TextAlign.left, fontWeight: FontWeight.w500),
                            subtitle: foundFournisseurs[index].solde != null ? textWorkSans("Solde: ${NumberFormat('#,###', 'fr_FR').format(foundFournisseurs[index].solde!)} ${widget.atelier.monnaie!.symbole}", 14, Colors.blueGrey, TextAlign.left,fontWeight: FontWeight.w600) : SizedBox(),
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
              child: textRaleway('${allFournisseurs.length} fournisseur(s)', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
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
          fontFamily: 'OpenSans'
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Rechercher un fournisseur',
          hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey, fontSize: 20)
      ),
      onChanged: (value) => runFilter(value),
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

  Future<void> getAllFournisseurs() async {

    startLoading();
    final response = await http.get(Uri.parse(AdminRoutes.r_getFournisseursUrl(widget.atelier.id!)),
      headers: Globals.apiHeaders,
    );
    endLoading();
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {

      allFournisseurs.clear();
      late Employe fournisseur;
      for(int i = 0; i < responseBody['data']['fournisseurs'].length; i++){
        fournisseur = Employe.fromJson(responseBody['data']['fournisseurs'][i]);
        allFournisseurs.add(fournisseur);
      }
      allFournisseurs.sort((a, b) => a.nom!.compareTo(b.nom!));
      setState(() {foundFournisseurs = allFournisseurs;});
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}");
    }
  }

  void runFilter(String enteredKeywords){
    List<Employe> results = [];
    if(enteredKeywords.isEmpty){
      // If all the searchField is empty or only contains white-space, we get all the list
      results = allFournisseurs;
    } else {
      results = allFournisseurs.where((element) => element.nom.toString().toLowerCase().contains(enteredKeywords.toLowerCase())).toList();
    }
    results.sort((a, b) => a.nom!.compareTo(b.nom!));
    setState(() {
      foundFournisseurs = results;
    });
  }

  Container showClientInfo(Employe fournisseur){
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.black,),
          ),
          SizedBox(height: 5,),
          textMontserrat(fournisseur.nom!, 20, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
          SizedBox(height: 10,),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Telephone 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Telephone mobile: ', fournisseurInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(fournisseur.tel_mobile != null? fournisseur.tel_mobile! : '', fournisseurInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // Telephone 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Telephone fixe: ', fournisseurInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(fournisseur.tel_fixe != null? fournisseur.tel_fixe! : '', fournisseurInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('E-mail: ', fournisseurInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(fournisseur.email != null? fournisseur.email! : '', fournisseurInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // ville
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Ville: ', fournisseurInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(fournisseur.ville != null? fournisseur.ville! : '', fournisseurInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // adresse
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Adresse: ', fournisseurInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(fournisseur.adresse != null? fournisseur.adresse! : '', fournisseurInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                ],
              )
          ),
          SizedBox(height: 7,),
        ],
      ),
    );
  }

}
