import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/screens/admin/admin_confection_creancier_page.dart';
import 'package:procouture/screens/admin/admin_tresorerie_banques_page.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/screens/admin/admin_transaction_confection_page.dart';
import 'package:procouture/screens/admin/admin_transaction_boutique_page.dart';

import '../../models/Atelier.dart';

class AdminTresorerieHomePage extends StatefulWidget {
  final Atelier atelier;
  AdminTresorerieHomePage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminTresorerieHomePage> createState() =>
      _AdminTresorerieHomePageState();
}

class _AdminTresorerieHomePageState extends State<AdminTresorerieHomePage> {

  bool isLoading = false;
  int currentIndex = 1;
  double iconSize = 22;
  double radius = 25;
  double titleTextSize = 19;
  double textSize = 13;
  //PageController pageController = PageController(initialPage: 0);

  Map<String, dynamic> tresorerieGenerale = {};
  Map<String, dynamic> tresorerieConfection = {};
  Map<String, dynamic> tresorerieBoutique = {};

  @override
  void initState() {
    loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: myDefaultAppBar('Trésorerie', context),
      body: isLoading ? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      menuItems(
                        CupertinoColors.activeBlue, Colors.white, Colors.white,"Générale","Solde:",
                          tresorerieGenerale['solde'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde'])} ${widget.atelier.monnaie!.symbole}" : '',
                        1),
                      menuItems(
                        CupertinoColors.activeGreen, Colors.white, Colors.white,"Confection","Chiffre Affaire:",
                          tresorerieGenerale['solde'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde'])} ${widget.atelier.monnaie!.symbole}" : '',
                        2),
                      menuItems(
                        CupertinoColors.activeOrange, Colors.black, Colors.black,"Boutique","Chiffre Affaire:",
                          tresorerieGenerale['solde'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde'])} ${widget.atelier.monnaie!.symbole}" : '',
                        3),
                      menuItems(
                          Colors.grey.shade300, Colors.black, Colors.black,"Banques","Chiffre Affaire:",
                          tresorerieGenerale['solde'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde'])} ${widget.atelier.monnaie!.symbole}" : '',
                          4),
                    ],
                  ),
                ),
              ),
            ),
            //SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: textMontserrat(libelle(), 15, Colors.grey, TextAlign.start, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25,),
            if(currentIndex == 1)
              menuTresorerieGen(),
            if(currentIndex == 2)
              menuConfection(),
            if(currentIndex == 3)
              menuBoutique(),
            if(currentIndex == 4)
              menuBanques(),
          ],
        ),
      ),
    );
  }


  
  Future<void> getTresorieGenerale() async {

    var request = http.Request('GET', Uri.parse(AdminRoutes.r_getTresorerieGeneraleUrl(widget.atelier.id!)));

    request.headers.addAll(Globals.apiHeaders);

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 200) {
      tresorerieGenerale['recettes'] = responseData['data']['recettes'];
      tresorerieGenerale['depenses'] = responseData['data']['depenses'];
      tresorerieGenerale['chiffre_affaire'] = responseData['data']['chiffre_affaire'];
      tresorerieGenerale['chiffre_affaire_confection'] = responseData['data']['chiffre_affaire_confection'];
      tresorerieGenerale['chiffre_affaire_boutique'] = responseData['data']['chiffre_affaire_boutique'];
      tresorerieGenerale['solde_caisse'] = responseData['data']['solde_caisse'];
      tresorerieGenerale['cumul_solde_banque'] = responseData['data']['cumul_solde_banque'];
      tresorerieGenerale['solde'] = responseData['data']['solde'];
      tresorerieGenerale['resultat'] = responseData['data']['resultat'];
      setState(() {});
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

  Future<void> getTresorieConfection() async {

    var request = http.Request('GET', Uri.parse(AdminRoutes.r_getTresorerieConfectionUrl(widget.atelier.id!)));

    request.headers.addAll(Globals.apiHeaders);

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 200) {

      tresorerieConfection['recettes'] = responseData['data']['recettes'];
      tresorerieConfection['depenses'] = responseData['data']['depenses'];
      tresorerieConfection['chiffre_affaire_confection'] = responseData['data']['chiffre_affaire_confection'];
      tresorerieConfection['solde_mois'] = responseData['data']['solde_mois'];
      tresorerieConfection['resultat'] = responseData['data']['resultat'];

      setState(() {});
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

  Future<void> getTresorieBoutique() async {

    var request = http.Request('GET', Uri.parse(AdminRoutes.r_getTresorerieBoutiqueUrl(widget.atelier.id!)));

    request.headers.addAll(Globals.apiHeaders);

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 200) {

      tresorerieBoutique['recettes'] = responseData['data']['recettes'];
      tresorerieBoutique['depenses'] = responseData['data']['depenses'];
      tresorerieBoutique['chiffre_affaire_boutique'] = responseData['data']['chiffre_affaire_boutique'];
      tresorerieBoutique['solde_mois'] = responseData['data']['solde_mois'];
      tresorerieBoutique['resultat'] = responseData['data']['resultat'];

      setState(() {});
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

  void loadAll(){
    getTresorieGenerale();
    getTresorieConfection();
    getTresorieBoutique();
  }

  Widget myIcon(int index, Color color){
    if(index == 1) {
      return Icon(Icons.payments_rounded, color: color, size: iconSize,);
    }
    if(index == 2) {
      return Icon(CupertinoIcons.scissors_alt, color: color,size: iconSize,);
    }
    if(index == 3) {
      return Icon(Icons.shopping_bag, color: color,size: iconSize,);
    }
    if(index == 4) {
      return Icon(Icons.account_balance_outlined, color: color,size: iconSize,);
    }
    return Icon(Icons.payments_rounded, color: color,);
  }

  Widget formerBody(){
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Opacity(
          opacity: 0.5,
          child: Container(
            //width: width,
            //height: width - 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Cfa1.jpg')
                )
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 45,),
                  CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () { Navigator.pop(context); },
                        icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          //margin: EdgeInsets.only(top: width - 80),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
        ),
        Container(
          //margin: EdgeInsets.only(top: width - 120),
          //padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    height: 270,
                    width: 300,
                    padding: const EdgeInsets.only(left: 25),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3,),
                        textWorkSans('SOLDE', 17, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                        textWorkSans(tresorerieGenerale['solde'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde'])} ${widget.atelier.monnaie!.symbole}" : '', 17, CupertinoColors.activeGreen,
                            TextAlign.start,
                            fontWeight: FontWeight.bold
                        ),
                        SizedBox(height: 7,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textWorkSans('Total recettes:', 16, Colors.black, TextAlign.start),
                            SizedBox(width: 5,),
                            textWorkSans(tresorerieGenerale['recettes'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['recettes'])} ${widget.atelier.monnaie!.symbole}":"",
                                16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textWorkSans('Total dépenses:', 16, Colors.black, TextAlign.start),
                            SizedBox(width: 5,),
                            textWorkSans(tresorerieGenerale['depenses'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['depenses'])} ${widget.atelier.monnaie!.symbole}": "",
                                16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textWorkSans('Résultat:', 16, Colors.black, TextAlign.start),
                            SizedBox(width: 5,),
                            textWorkSans(tresorerieGenerale['resultat'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['resultat'])} ${widget.atelier.monnaie!.symbole}" : "",
                                16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textWorkSans("Chiffre d'affaire:", 16,
                                Colors.black, TextAlign.start),
                            SizedBox(width: 5,),
                            textWorkSans(tresorerieGenerale['resultat'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['resultat'])} ${widget.atelier.monnaie!.symbole}":"",
                                16, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        textWorkSans('SOLDE CAISSE', 17, Colors.black,
                            TextAlign.start, fontWeight: FontWeight.w500
                        ),
                        textWorkSans(tresorerieGenerale['solde_caisse'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde_caisse'])} ${widget.atelier.monnaie!.symbole}":"", 17, CupertinoColors.activeGreen,
                            TextAlign.start, fontWeight: FontWeight.bold
                        ),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                textMontserrat('Toutes les transactions', 14, Colors.black, TextAlign.center),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    height: 200,
                    //color: Colors.blue,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(children: [
                        Container(
                          height: 180,
                          width: 180,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(12),
                            //boxShadow: [kDefaultBoxShadow2]
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Icon(CupertinoIcons.scissors, color: Colors.white,
                                ),
                              ),
                              textMontserrat('Confection', 17, Colors.white, TextAlign.center, fontWeight: FontWeight.bold),
                              textMontserrat("Chiffre d'affaire", 12, Colors.white, TextAlign.center),
                              textMontserrat(tresorerieGenerale['chiffre_affaire_confection'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['chiffre_affaire_confection'])} ${widget.atelier.monnaie!.symbole}" :"",
                                  16, Colors.white, TextAlign.center
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 180,
                          width: 180,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(12),
                            //boxShadow: [kDefaultBoxShadow2]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Icon(Icons.shopping_bag_rounded, color: Colors.white,),
                              ),
                              textMontserrat('Boutique', 17, Colors.white, TextAlign.center, fontWeight: FontWeight.bold),
                              textMontserrat("Chiffre d'affaire", 12, Colors.white, TextAlign.center),
                              textMontserrat(tresorerieGenerale['chiffre_affaire_boutique'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['chiffre_affaire_boutique'])} ${widget.atelier.monnaie!.symbole}":"",
                                  16, Colors.white, TextAlign.center
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 180,
                          width: 180,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                            //boxShadow: [kDefaultBoxShadow2]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Icon(Icons.account_balance, color: Colors.white,),
                              ),
                              textMontserrat("Banques", 17, Colors.white, TextAlign.center, fontWeight: FontWeight.bold),
                              textMontserrat("Solde banques", 12, Colors.white, TextAlign.center),
                              textMontserrat(
                                tresorerieGenerale['cumul_solde_banque'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['cumul_solde_banque'])} ${widget.atelier.monnaie!.symbole}":"",
                                16, Colors.white, TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget menuItems(Color bgColor, Color textColor, Color iconColor, String title, String subTitle, String amount,int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          currentIndex = index;
          //pageController.jumpToPage(currentIndex);
        });
      },
      child: Container(
        height: 150,
        width: 260,
        margin: EdgeInsets.only(right: 13),
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: iconColor.withOpacity(0.2),
              child: myIcon(index, iconColor),
            ),
            textMontserrat(title, titleTextSize, textColor, TextAlign.start, fontWeight: FontWeight.w600),
            SizedBox(height: 10,),
            Row(
              children: [
                textMontserrat(subTitle, textSize, textColor, TextAlign.start, fontWeight: FontWeight.w300),
                SizedBox(width: 4,),
                textMontserrat(amount, textSize, textColor, TextAlign.start, fontWeight: FontWeight.bold),
              ],
            ),
            SizedBox(height: 2,)
          ],
        ),
      ),
    );
  }

  Widget menuTresorerieGen(){
    return Container(
      height: 270,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 25, top: 10, bottom: 10),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [kDefaultBoxShadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3,),
          textMontserrat("Solde", 20, Colors.black, TextAlign.start, fontWeight: FontWeight.bold),
          textMontserrat(tresorerieGenerale["solde"] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde'])} ${widget.atelier.monnaie!.symbole}" : "", 21, CupertinoColors.activeGreen,
              TextAlign.start,
              fontWeight: FontWeight.bold
          ),
          SizedBox(height: 7,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textMontserrat('Total recettes:', 16, Colors.black, TextAlign.start),
              SizedBox(width: 5,),
              textMontserrat(tresorerieGenerale['recettes'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['recettes'])} ${widget.atelier.monnaie!.symbole}" : "",
                  18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textMontserrat('Total dépenses:', 16, Colors.black, TextAlign.start),
              SizedBox(width: 5,),
              textMontserrat(tresorerieGenerale['depenses'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['depenses'])} ${widget.atelier.monnaie!.symbole}" : "",
                  18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textMontserrat("Résultat:", 16, Colors.black, TextAlign.start),
              SizedBox(width: 5,),
              textMontserrat(tresorerieGenerale['resultat'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['resultat'])} ${widget.atelier.monnaie!.symbole}" : "",
                  18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textMontserrat("Chiffre d'affaire:", 16,
                  Colors.black, TextAlign.start),
              SizedBox(width: 5,),
              textMontserrat(tresorerieGenerale['resultat'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['resultat'])} ${widget.atelier.monnaie!.symbole}":"",
                  18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
              ),
            ],
          ),
          SizedBox(height: 10,),
          textMontserrat("Solde caisse", 20, Colors.black,
              TextAlign.start, fontWeight: FontWeight.bold
          ),
          textMontserrat(tresorerieGenerale['solde_caisse'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde_caisse'])} ${widget.atelier.monnaie!.symbole}":"", 21, CupertinoColors.activeGreen,
              TextAlign.start, fontWeight: FontWeight.bold
          ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }

  Widget menuConfection(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 25),
            //margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [kDefaultBoxShadow],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3,),
                textMontserrat("Chiffre d'affaire", 22, Colors.black, TextAlign.start, fontWeight: FontWeight.bold),
                textMontserrat(tresorerieConfection['chiffre_affaire_confection'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieConfection['chiffre_affaire_confection'])} ${widget.atelier.monnaie!.symbole}" : '', 24, CupertinoColors.activeGreen,
                    TextAlign.start,
                    fontWeight: FontWeight.bold
                ),
                SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat('Recettes:', 16, Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieConfection['recettes'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieConfection['recettes'])} ${widget.atelier.monnaie!.symbole}":"",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat('Dépenses:', 16, Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieConfection['depenses'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieConfection['depenses'])} ${widget.atelier.monnaie!.symbole}": "",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat('Résultat:', 16, Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieConfection['resultat'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieConfection['resultat'])} ${widget.atelier.monnaie!.symbole}" : "",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat("Solde du mois:", 16,
                        Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieConfection['solde_mois'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieConfection['solde_mois'])} ${widget.atelier.monnaie!.symbole}":"",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                SizedBox(height: 5,),
              ],
            ),
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 170,
                width: MediaQuery.of(context).size.width * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [kDefaultBoxShadow],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: CupertinoColors.activeGreen,
                      child: Icon(Icons.compare_arrows, size: 20, color: Colors.white,),
                    ),
                    Container(alignment: Alignment.center, height:40, child: textMontserrat("Transactions", 13, Colors.black, TextAlign.center, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTransactionConfectionPage(atelier: widget.atelier,)));
                      },
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        //padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeGreen,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: textMontserrat("Voir", 13, Colors.white, TextAlign.center, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 170,
                width: MediaQuery.of(context).size.width * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [kDefaultBoxShadow],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: CupertinoColors.activeGreen,
                      child: Icon(Icons.person, size: 20, color: Colors.white,),
                    ),
                    Container(alignment: Alignment.center, height:40, child: textMontserrat("Liste des créanciers", 13, Colors.black, TextAlign.center, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminConfectionCreancierPage(atelier: widget.atelier,)));
                      },
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        //padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeGreen,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: textMontserrat("Voir", 13, Colors.white, TextAlign.center, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuBoutique(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 25),
            //margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [kDefaultBoxShadow],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3,),
                textMontserrat("Chiffre d'affaire", 22, Colors.black, TextAlign.start, fontWeight: FontWeight.bold),
                textMontserrat(tresorerieBoutique['chiffre_affaire_boutique'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieBoutique['chiffre_affaire_boutique'])} ${widget.atelier.monnaie!.symbole}" : "", 24, CupertinoColors.activeGreen,
                    TextAlign.start,
                    fontWeight: FontWeight.bold
                ),
                SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat('Recettes:', 16, Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieBoutique['recettes'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieBoutique['recettes'])} ${widget.atelier.monnaie!.symbole}":"",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat('Dépenses:', 16, Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieBoutique['depenses'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieBoutique['depenses'])} ${widget.atelier.monnaie!.symbole}": "",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat('Résultat:', 16, Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieBoutique['resultat'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieBoutique['resultat'])} ${widget.atelier.monnaie!.symbole}" : "",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textMontserrat("Solde du mois:", 16, Colors.black, TextAlign.start),
                    SizedBox(width: 5,),
                    textMontserrat(tresorerieBoutique['solde_mois'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieBoutique['solde_mois'])} ${widget.atelier.monnaie!.symbole}":"",
                        18, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700
                    ),
                  ],
                ),
                SizedBox(height: 5,),
              ],
            ),
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 170,
                width: MediaQuery.of(context).size.width * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [kDefaultBoxShadow],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: CupertinoColors.activeOrange,
                      child: Icon(Icons.compare_arrows, size: 20, color: Colors.black,),
                    ),
                    textMontserrat("Transactions", 13, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTransactionBoutiquePage(atelier: widget.atelier,)));
                      },
                      child: Container(
                        height: 35,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        //padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeOrange,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: textMontserrat("Voir", 13, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuBanques(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminTresorerieBanquePage(atelier: widget.atelier,)));
        },
        child: Container(
          height: 60,
          width: double.infinity,
          margin: EdgeInsets.only(top: 70),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: CupertinoColors.white,
            boxShadow: [kDefaultBoxShadow]
          ),
          child: textMontserrat("Voir les banques", 17, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String libelle(){
    if(currentIndex == 1){
      return "Trésorerie générale";
    }
    if(currentIndex == 2){
      return "Trésorerie confection";
    }
    if(currentIndex == 3){
      return "Trésorerie boutique";
    }
    if(currentIndex == 4){
      return "Trésorerie banques";
    }

    return "Trésorerie générale";
  }
  void loadingProgress(bool value) {
    if (value) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}

// tresorerieGenerale['solde'] != null ? "${NumberFormat('#,###', 'fr_FR').format(tresorerieGenerale['solde'])} ${widget.atelier.monnaie!.symbole}" : ''
