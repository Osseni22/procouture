import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/screens/boutique/vente_du_jour.dart';
import 'package:procouture/screens/confection/catalogue/catalogue_album.dart';
import 'package:procouture/screens/home/statistiques.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../screens/confection/client/rdv_imminent_page.dart';
import 'package:procouture/screens/confection/commande/commande_du_jour.dart';
import '../screens/confection/commande/livraison_page.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  double width = 0;
  double notifValueSize = 15;
  double notifTextSize = 12;
  int animationDuration = 500;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width * 0.8;
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: width/2,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/ProCouture_Decor_Confec.png')
                ),
                borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        spreadRadius: 2
                    )
                  ]
              ),
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: textRaleway('Confection des \n Vêtements', 21, Colors.white.withOpacity(0.8), TextAlign.left),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                      child: GestureDetector(
                        onTap: (){
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const Statistiques()));
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          padding: EdgeInsets.only(left: 3),
                          alignment: Alignment.centerLeft,
                          /*decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white.withOpacity(0.07)
                          ),*/
                          //child: textRaleway('Statistiques >>', 12, Colors.white.withOpacity(0.8), TextAlign.left)),
                          child: Icon(CupertinoIcons.chart_pie_fill, size: 20, color: Colors.white54,),
                      ),
                    ),
                  ),
                  )
                ]
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              width: width,
              height: width/2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const Livraison()));
                    },
                    child: FadeIn(
                      // Optional paramaters
                      duration: Duration(milliseconds: animationDuration),
                      curve: Curves.fastOutSlowIn,
                      child: Container(
                        width: width/2 - 10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              spreadRadius: 2
                            )
                          ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            textMontserrat('A livrer dans les 3 jours', notifTextSize, Colors.black, TextAlign.center),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red.withOpacity(0.8),
                              //child: Icon(CupertinoIcons.bell_fill, size: 29,color: Colors.white),
                              child: FaIcon(FontAwesomeIcons.bell, size: 29, color: Colors.white),
                            ),
                            textMontserrat('99+', notifValueSize, Colors.black, TextAlign.center,fontWeight: FontWeight.w600),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const RdvImminent()));
                    },
                    child: FadeIn(
                      // Optional paramaters
                      duration: Duration(milliseconds: animationDuration),
                      curve: Curves.bounceOut,
                      child: Container(
                        width: width/2 - 10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  spreadRadius: 2
                              )
                            ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            textMontserrat('Rendez-vous', notifTextSize, Colors.black, TextAlign.center),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.indigo.withOpacity(0.7),
                              child: Icon(Icons.event_note, size: 29,color: Colors.white),
                            ),
                            textMontserrat('99+', notifValueSize, Colors.black, TextAlign.center,fontWeight: FontWeight.w600),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              width: width,
              height: width/2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const CommandeDuJour()));
                    },
                    child: Container(
                      width: width/2 - 10,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.pink.withOpacity(0.02),
                                blurRadius: 10,
                                spreadRadius: 2
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textMontserrat('Commandes du jour', notifTextSize, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber.withOpacity(0.7),
                            child: Icon(Icons.shopping_bag_outlined, size: 29,color: Colors.white),
                          ),
                          textMontserrat('99+', notifValueSize, Colors.black, TextAlign.center,fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CatalogueAlbum()));
                    },
                    child: Container(
                      width: width/2 - 10,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                spreadRadius: 2
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textMontserrat('Modèles (album)', notifTextSize, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.purple.withOpacity(0.7),
                            child: Icon(Icons.photo_library_rounded, size: 29,color: Colors.white),
                          ),
                          textMontserrat('99+', notifValueSize, Colors.black, TextAlign.center,fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            FadeIn(
              // Optional paramaters
              duration: Duration(milliseconds: animationDuration),
              curve: Curves.easeIn,
              child: Container(
                width: width,
                height: width/2,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/ProCouture_Decor_Boutique_2_compressed.png')
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          spreadRadius: 2
                      )
                    ]
                ),
                child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: textRaleway('Boutique', 21, Colors.black.withOpacity(0.8), TextAlign.right),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
                          child: GestureDetector(
                            onTap: (){
                              HapticFeedback.mediumImpact();
                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const Statistiques()));
                            },
                            child: Container(
                                width: 30,
                                height: 30,
                                padding: EdgeInsets.only(left: 3),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                   // color: Colors.black.withOpacity(0.03),
                                  //border: Border.all(color: Colors.black.withOpacity(0.1))
                                ),
                                //child: textRaleway('Statistiques >>', 12, Colors.black54.withOpacity(0.3), TextAlign.left)),
                                child: Icon(CupertinoIcons.chart_pie_fill, size: 20, color: Colors.black26,),
                          ),
                        ),
                      ),
                      )
                    ]
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: width,
              height: width/2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> VenteDuJour()));
                    },
                    child: Container(
                      width: width/2 - 10,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                spreadRadius: 2
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textMontserrat('Ventes du jour', notifTextSize, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.deepOrangeAccent.withOpacity(0.7),
                            child: const Icon(Icons.shopping_cart, size: 29,color: Colors.white),
                          ),
                          textMontserrat('99+', notifValueSize, Colors.black, TextAlign.center,fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Fluttertoast.showToast(
                          msg: 'En cours...'
                      );
                    },
                    child: Container(
                      width: width/2 - 10,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                spreadRadius: 2
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textMontserrat('Total articles', notifTextSize, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green.withOpacity(0.7),
                            child: const FaIcon(FontAwesomeIcons.blackTie, size: 29,color: Colors.white),
                          ),
                          textMontserrat('99+', notifValueSize, Colors.black, TextAlign.center,fontWeight: FontWeight.w600),
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
    );
  }
}
