//import 'dart:html';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/default_app_bar.dart';

class AProposPage extends StatefulWidget {
  AProposPage({Key? key}) : super(key: key);

  @override
  State<AProposPage> createState() => _AProposPageState();
}

class _AProposPageState extends State<AProposPage> {

  String first = "ProCouture est une plateforme mobile & web de gestion des ateliers de couture, de mise en relation entre les couturiers et les usagers, et de gestion des boutiques de vêtements et accessoires de mode.";

  String second = "Elle permet aux couturiers de restés concentrés sur leur cœur de métier et d’avoir une vue à 360° sur leur gestion à travers les fonctionnalités suivantes :";

  String third = "Enregistrement des clients (nom, mesures, et commandes) ; gestion de la production ; Rappel des RDV d’essai et de retrait de commandes (fini le sempiternel problème de non-respect des rdv) ; Gestion de la comptabilité simplifiée ; Edition de factures ; Gestion des statistiques afin d’anticiper sur les prêts à porter, Gestion des fournisseurs).";

  String fourth = "Elle permet aux Couturiers et aux Boutiques de vêtements et accessoires d’améliorer leur visibilité et d’accroître leur chiffre d’affaires à travers le module de gestion de Boutique en ligne pour la vente de prêt-à-porter avec gestion du stock intégrée.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('A Propos', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Image(image: AssetImage('assets/images/appstore.png'),height: 150, width: 150,),
              //SizedBox(height: 20,),
              //textRaleway('Expiration de la licence le : 31/12/2023', 16, Colors.black, TextAlign.center),
              SizedBox(height: 30,),
              Expanded(
                child: Container(
                  //height: 400,
                  child: ListView(
                    children: [
                      InkWell(
                        onTap: (){/*Navigator.of(context).push(MaterialPageRoute(builder: (_) => AProposPage()));*/},
                        child: ListTile(
                          leading: Icon(Icons.help,color: Colors.grey, size: 35,),
                          title: textMontserrat('Version de l\'application', 15, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway('1.0.0', 16, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: (){ rateApp();},
                        child: ListTile(
                          leading: Icon(Icons.star,color: Colors.grey, size: 35,),
                          title: textMontserrat("Noter l'application", 15, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway("Dites ce que vous pensez de l'application", 14, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: (){
                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            builder: (BuildContext ctx) => showAppDetails());
                        },
                        child: ListTile(
                          leading: Icon(Icons.info,color: Colors.grey, size: 35,),
                          title: textMontserrat('ProCouture Mobile', 15, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway('En savoir plus sur l\'application', 14, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),
                      /*InkWell(
                        onTap: (){*//*Navigator.of(context).push(MaterialPageRoute(builder: (_) => AProposPage()));*//*},
                        child: ListTile(
                          leading: Icon(Icons.lock_open_outlined,color: Colors.grey, size: 35,),
                          title: textLato('Activer ProCouture', 17, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway('Quitter la version d\'essai et activer l\'application', 14, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),*/
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void rateApp() async {

    final String packageName = 'com.ecinov.procouture'; // Replace with your app's package name
    final urlPlayStore = 'https://play.google.com/store/apps/details?id=$packageName';

    if(Platform.isAndroid) {
      if (await canLaunchUrlString(urlPlayStore)) {
        await launchUrlString(urlPlayStore, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlPlayStore';
      }
    }

  }

  Container showAppDetails(){
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            textMontserrat('A Propos', 20, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
            SizedBox(height: 10,),
            Container(
              height: 110,
                //color: Colors.grey.shade300,
              child: Text(
                first,
                style: TextStyle(fontSize: 17),
              )
            ),
            SizedBox(height: 10,),
            Container(
              height: 90,
              //color: Colors.grey.shade300,
              child: Text(
                second,
                style: TextStyle(fontSize: 17),
              )
            ),
            SizedBox(height: 10,),
            Container(
              height: 170,
                //color: Colors.grey.shade300,
              child: Text(
                third,
                style: TextStyle(fontSize: 17),
              )
            ),
            SizedBox(height: 10,),
            Container(
              height: 140,
                //color: Colors.grey.shade300,
              child: Text(
                fourth,
                style: TextStyle(fontSize: 17),
              )
            ),
            SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
}

