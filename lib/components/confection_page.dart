import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procouture/screens/confection/client/client_page.dart';
import 'package:procouture/screens/confection/commande/commande_page.dart';
import 'package:procouture/screens/confection/employe/employes_page.dart';
import 'package:procouture/screens/confection/fournisseur/fournisseur_page.dart';

import '../screens/confection/transaction/caisse_menu_page.dart';
import '../screens/confection/produit/catalogue_page.dart';
import '../widgets/custom_text.dart';

class ConfectionPage extends StatelessWidget {
  const ConfectionPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: width/3,
              alignment: Alignment.center,
              //color: Colors.grey.shade50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textRaleway('Confection des \nVêtements', 22, Colors.black87, TextAlign.left),
                    Container(
                        width: width/3,
                        height: width/3,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/tailoring.gif')
                              //image: AssetImage('assets/images/sewing-pattern-5067653_1920.png')
                          ),
                        )
                    )
                  ]
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClientPage()));
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
                          textMontserrat('Clients', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.withOpacity(0.7),
                            child: Icon(Icons.group_sharp, size: 29,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CommandePage()));
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
                          textMontserrat('Commandes', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.indigo.withOpacity(0.7),
                            child: Icon(Icons.shopping_basket_rounded, size: 29,color: Colors.white),
                          ),
                        ],
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
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CataloguePage()));
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
                          textMontserrat('Catalogue', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber.withOpacity(0.7),
                            child: const FaIcon(FontAwesomeIcons.blackTie, size: 29,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => EmployePage()));
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
                          textMontserrat('Tâches', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.purple.withOpacity(0.7),
                            child: Icon(Icons.task_rounded, size: 29,color: Colors.white),
                          ),
                        ],
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
                      Navigator.push(context, MaterialPageRoute(builder: (_) => MenuCaise()));
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
                          textMontserrat('Trésorerie', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.deepOrangeAccent.withOpacity(0.7),
                            child: Icon(Icons.payments_rounded, size: 29,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FournisseurPage()));
                      //Fluttertoast.showToast(msg: 'Bien');
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
                          textMontserrat('Fournisseurs', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green.withOpacity(0.7),
                            child: Icon(CupertinoIcons.group_solid, size: 29,color: Colors.white),
                          ),
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
