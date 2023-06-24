import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:http/http.dart' as http;

import '../../models/Atelier.dart';
import '../../models/TacheLibre.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/globals/global_var.dart';


class AdminTacheLibrePage extends StatefulWidget {
  final Atelier atelier;
  const AdminTacheLibrePage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminTacheLibrePage> createState() => _AdminTacheLibrePageState();
}

class _AdminTacheLibrePageState extends State<AdminTacheLibrePage> {

  bool isLoading = false;

  List<TacheLibre> allTacheLibres = [];
  TacheLibre? selectedTache;
  
  @override
  void initState() {
    getAllTaches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Tâches libres', context),
      backgroundColor: Colors.grey.shade100,
      body: isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: allTacheLibres.length,
                  itemBuilder: (context, int index) => GestureDetector(
                    onTap: (){
                      selectedTache = allTacheLibres[index];
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(13),
                            )
                          ),
                          builder: (context) => taskDetails(selectedTache!)
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Nom de l'employé
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textMontserrat(allTacheLibres[index].nom!.toUpperCase(), 13, Colors.black, TextAlign.center,fontWeight: FontWeight.w800),
                              SizedBox(width: 10,),
                              Icon(CupertinoIcons.person_fill, color: Colors.black45,),
                            ],
                          ),
                          // Date de début de la tâche
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textMontserrat(Globals.convertDateEnToFr(allTacheLibres[index].date_debut!)!, 14, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
                              SizedBox(width: 10,),
                              Icon(CupertinoIcons.calendar, color: Colors.black45,),
                            ],
                          ),
                          // Description
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textMontserrat(allTacheLibres[index].description != null ? allTacheLibres[index].description! : '', 14, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
                              SizedBox(width: 10,),
                              Icon(CupertinoIcons.doc_text, color: Colors.black45,),
                            ],
                          ),
                          // Montant de la tâche
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textMontserrat(allTacheLibres[index].montant != null ? "${NumberFormat('#,###', 'fr_FR').format(allTacheLibres[index].montant)} ${widget.atelier.monnaie!.symbole}" : '', 14, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
                              SizedBox(width: 10,),
                              Icon(CupertinoIcons.money_dollar, color: Colors.black45,),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: CupertinoColors.activeGreen,
                            ),
                            child: textMontserrat('Voir détails', 15, Colors.white, TextAlign.center),
                          )
                        ],
                      ),
                    ),
                  )
              )
            ),
            Container(
              alignment: Alignment.centerRight,
              height: 30,
              child: textMontserrat('${allTacheLibres.length} Tâches', 15, Colors.black, TextAlign.end),
            )
          ],
        ),
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

  Future<void> getAllTaches() async {
    var request = http.Request('GET', Uri.parse(AdminRoutes.r_getTachesLibresUrl(widget.atelier.id!)));

    request.headers.addAll(Globals.apiHeaders);

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 200) {
      allTacheLibres.clear();
      late TacheLibre tacheLibre;
      print(responseData['data']['taches_libres']);
      for(int i = 0; i < responseData['data']['taches_libres'].length; i++){
        tacheLibre = TacheLibre.fromJson(responseData['data']['taches_libres'][i]);
        allTacheLibres.add(tacheLibre);
      }
      allTacheLibres.sort((a,b) => b.id!.compareTo(a.id!));
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

  Container taskDetails(TacheLibre tacheLibre) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textMontserrat('Détails de la tâche', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Employé:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat(tacheLibre.nom!, 16, Colors.black, TextAlign.start,),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Date début:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat(Globals.convertDateEnToFr(tacheLibre.date_debut!)!, 16, Colors.black, TextAlign.start),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Description:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat(tacheLibre.description!, 16, Colors.black, TextAlign.start,),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.looks_two_rounded, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Quantité:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat(tacheLibre.qte.toString(), 16, Colors.black, TextAlign.start,),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payments_outlined, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Commission:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat("${NumberFormat('#,###', 'fr_FR').format(tacheLibre.comission)} ${widget.atelier.monnaie!.symbole}", 16, Colors.black, TextAlign.start,),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payments_outlined, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Montant:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat("${NumberFormat('#,###', 'fr_FR').format(tacheLibre.montant)} ${widget.atelier.monnaie!.symbole}", 16, Colors.black, TextAlign.start,),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.blackTie, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Modèle:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat(tacheLibre.product != null ? tacheLibre.product!.libelle! : '', 16, Colors.black, TextAlign.start,),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_4, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Client:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat(tacheLibre.client != null ? tacheLibre.client!.nom! : '', 16, Colors.black, TextAlign.start,),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timelapse, color: Colors.grey,),
                  SizedBox(width: 5,),
                  textMontserrat("Etat:", 16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w500),
                ],
              ),
              textMontserrat(tacheLibre.etat!.libelle!, 16, Colors.black, TextAlign.start,),
            ],
          ),
        ],
      ),
    );
  }

}
