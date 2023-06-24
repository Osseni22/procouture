import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/screens/admin/admin_banques_page.dart';
import 'package:procouture/screens/admin/admin_client_page.dart';
import 'package:procouture/screens/admin/admin_commande_page.dart';
import 'package:procouture/screens/admin/admin_fournisseur_page.dart';
import 'package:procouture/screens/admin/admin_employes_page.dart';
import 'package:procouture/screens/admin/admin_tache_libre_page.dart';
import 'package:procouture/screens/admin/admin_atelier_save_page.dart';
import 'package:procouture/screens/admin/admin_tresorerie_home_page.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/widgets/default_box_shadow.dart';
import 'package:procouture/screens/admin/admin_atelier_users_page.dart';

import '../../models/Atelier.dart';
import '../../services/api_routes/routes.dart';
import '../../widgets/custom_text.dart';

class AdminAtelierHomePage extends StatefulWidget {
  final Atelier atelier;
  const AdminAtelierHomePage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminAtelierHomePage> createState() => _AdminAtelierHomePageState();
}

class _AdminAtelierHomePageState extends State<AdminAtelierHomePage>{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool isLoading = false;

  int nbreClients = 0;
  int nbreCommandes = 0;
  int nbreEmployes = 0;
  int nbreFournisseurs = 0;
  int nbreBanques = 0;
  int nbreUsers = 0;

  //int nbreClients = 0;
  EdgeInsets defaultPadding = const EdgeInsets.symmetric(horizontal: 50);
  double iconSize = 30;
  double avatarRaduis = 30;

  double heightDivider = 2.7;
  double widthDivider = 2.9;

  @override
  void initState() {
    loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      body:
      Stack(
        children: [
          /// Top zone
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/tailoring-2575930_1920_invert.jpg')
              )
              //color: Colors.grey.withOpacity(0.3)
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35,),
                  Container(
                    height: 40,
                    //color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
                        Visibility(
                          visible: false,
                          child: Container(
                            height: 100,
                            child: IconButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAtelierSavePage(pageMode: 'M', atelier: widget.atelier,)));
                                },
                                icon: Icon(Icons.store_mall_directory_rounded, color: Colors.white, size: 28,),
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
          /// Bottom zone
          Container(
            margin: EdgeInsets.only(top: 278),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  /// User et banques
                  Padding(
                    padding: defaultPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (_)=> AtelierUsersPage(atelier: widget.atelier,)));
                              loadAll();
                            },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [kDefaultBoxShadow],
                                color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.lightBlue.withOpacity(0.15),
                                        child: Icon(Icons.person, color: Colors.lightBlue, size: iconSize,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Utilisateurs', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminBanquesPage(atelier: widget.atelier,)));
                              loadAll();
                            },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [kDefaultBoxShadow],
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.yellow.withOpacity(0.15),
                                        child: Icon(Icons.account_balance_outlined, color: Colors.yellow, size: iconSize,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Banques', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /// Client et Commandes
                  SizedBox(height: 18,),
                  Padding(
                    padding: defaultPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminClientPage(atelier: widget.atelier,))); },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [kDefaultBoxShadow],
                                  color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.deepPurple.withOpacity(0.15),
                                        child: Icon(CupertinoIcons.person_2_alt, color: Colors.deepPurple, size: iconSize-4,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Clients', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminCommandePage(atelier: widget.atelier,))); },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [kDefaultBoxShadow],
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.deepOrange.withOpacity(0.15),
                                        child: Icon(Icons.shopping_basket_rounded, color: Colors.deepOrange, size: iconSize,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Commandes', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /// Trésorerie et Fournisseurs
                  SizedBox(height: 18,),
                  Padding(
                    padding: defaultPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTresorerieHomePage(atelier: widget.atelier,)));
                            },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [kDefaultBoxShadow],
                                  color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.blueGrey.withOpacity(0.15),
                                        child: Icon(CupertinoIcons.money_dollar, color: Colors.blueGrey, size: iconSize,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Trésorerie', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=> AdminFournisseurPage(atelier: widget.atelier,)));
                            },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [kDefaultBoxShadow],
                                  color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.indigo.withOpacity(0.15),
                                        child: Icon(CupertinoIcons.group_solid, color: Colors.indigo, size: iconSize,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Fournisseurs', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /// Employés et Tâches libres
                  SizedBox(height: 18,),
                  Padding(
                    padding: defaultPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployePage(atelier: widget.atelier,)));
                            },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [kDefaultBoxShadow],
                                  color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.red.withOpacity(0.15),
                                        child: Icon(CupertinoIcons.doc_person, color: Colors.red, size: iconSize,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Employés', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isLoading? 0.0 : 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTacheLibrePage(atelier: widget.atelier,)));
                            },
                            child: Container(
                              height: size/heightDivider,
                              width: size/widthDivider,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [kDefaultBoxShadow],
                                color: Colors.white
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: avatarRaduis,
                                        backgroundColor: Colors.green.withOpacity(0.15),
                                        child: Icon(Icons.task, color: Colors.green, size: iconSize,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: size * 0.12,
                                    alignment: Alignment.topCenter,
                                    //color: Colors.white,
                                    child: textMontserrat('Tâches Libres', 12, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18,),
                ],
              ),
            ),
          ),
          /// Recap zone
          AnimatedPositioned(
            duration: Duration(milliseconds: 600),
            top: 100,
            left: isLoading? - 250 : 10,
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width * 0.55,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.15)
              ),
              //color: Colors.white.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textMontserrat(widget.atelier.libelle!, 16, Colors.white, TextAlign.start, fontWeight: FontWeight.w500),
                  textMontserrat("(${widget.atelier.identifiant!})", 10, Colors.white, TextAlign.start, fontWeight: FontWeight.w300),
                  //textWorkSans("Solde: ${NumberFormat('#,###', 'fr_FR').format(widget.atelier.solde!)} ${widget.atelier.monnaie!.symbole!}", 15, Colors.black, TextAlign.start, fontWeight: FontWeight.w400),
                  SizedBox(height: 10,),
                  textMontserrat("$nbreUsers Utilisateur(s)", 12, Colors.white, TextAlign.start, fontWeight: FontWeight.w400),
                  textMontserrat("$nbreBanques Banque(s)", 12, Colors.white, TextAlign.start, fontWeight: FontWeight.w400),
                  textMontserrat("$nbreClients Client(s)", 12, Colors.white, TextAlign.start, fontWeight: FontWeight.w400),
                  textMontserrat("$nbreEmployes Employé(s)", 12, Colors.white, TextAlign.start, fontWeight: FontWeight.w400),
                  textMontserrat("$nbreFournisseurs Fournisseur(s)", 12, Colors.white, TextAlign.start, fontWeight: FontWeight.w400),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  void loadingIndicator(bool value){
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

  void loadAll(){
    countUsers();
    countBanques();
    countClients();
    countEmployes();
    countFournisseurs();
  }

  // Clients
  Future<void> countClients() async {

    loadingIndicator(true);
    final response = await http.get(
      Uri.parse(AdminRoutes.r_getClientsUrl(widget.atelier.id!)),
      headers: Globals.apiHeaders,
    );
    loadingIndicator(false);

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        nbreClients = responseBody['data']['clients'].length;
      });
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}", toastLength: Toast.LENGTH_LONG);
    }
  }
  // Fournisseurs
  Future<void> countFournisseurs() async {
    loadingIndicator(true);
    final response = await http.get(
      Uri.parse(AdminRoutes.r_getFournisseursUrl(widget.atelier.id!)),
      headers: Globals.apiHeaders,
    );
    loadingIndicator(false);

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        nbreFournisseurs = responseBody['data']['fournisseurs'].length;
      });
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}", toastLength: Toast.LENGTH_LONG);
    }
  }
  // Users
  Future<void> countUsers() async {
    loadingIndicator(true);
    final response = await http.get(
      Uri.parse('$r_ateliers/${widget.atelier.id!}/users'),
      headers: Globals.apiHeaders,
    );
    loadingIndicator(false);


    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        nbreUsers = responseBody['data']['users'].length;
      });
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}", toastLength: Toast.LENGTH_LONG);
    }
  }
  // Banques
  Future<void> countBanques() async {
    loadingIndicator(true);
    final response = await http.get(
      Uri.parse(AdminRoutes.r_getBanquesUrl(widget.atelier.id!)),
      headers: Globals.apiHeaders,
    );
    loadingIndicator(false);

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        nbreBanques = responseBody['data']['banques'].length;
      });
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}", toastLength: Toast.LENGTH_LONG);
    }
  }
  // Employés
  Future<void> countEmployes() async {
    loadingIndicator(true);
    final response = await http.get(
      Uri.parse(AdminRoutes.r_getEmployesUrl(widget.atelier.id!)),
      headers: Globals.apiHeaders,
    );
    loadingIndicator(false);

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      setState(() {
        nbreEmployes = responseBody['data']['employes'].length;
      });
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}", toastLength: Toast.LENGTH_LONG);
    }
  }

}
