import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procouture/screens/boutique/mouvement_stock_page.dart';
import 'package:procouture/screens/boutique/stock_articles_page.dart';

import '../screens/boutique/articles_page.dart';
import '../screens/boutique/vente_page.dart';
import '../widgets/custom_text.dart';

class BoutiquePage extends StatelessWidget {
  const BoutiquePage({Key? key}) : super(key: key);

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
              //color: Colors.grey.shade50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textRaleway('Gestion de la \nBoutique', 22, Colors.black87, TextAlign.left),
                    Container(
                        width: width/3,
                        height: width/3,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/yellow-shopping-bag.png')
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VentePage()));
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
                          textMontserrat('Ventes', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.withOpacity(0.7),
                            child: Icon(Icons.shopping_bag_rounded, size: 29,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlePage()));
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
                          textMontserrat('Articles', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.indigo.withOpacity(0.7),
                            child: const FaIcon(FontAwesomeIcons.blackTie, size: 29,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockPage()));
                      //Fluttertoast.showToast(msg: 'Disponible ultérieurement');
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
                          textMontserrat('Stock', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber.withOpacity(0.7),
                            child: Icon(Icons.inventory_2_rounded, size: 29,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MouvementStock()));
                      //Fluttertoast.showToast(msg: 'Disponible ultérieurement');
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
                          textMontserrat('Mouvements stock', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.purple.withOpacity(0.7),
                            child: Icon(Icons.move_down_sharp, size: 29,color: Colors.white),
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
                      Fluttertoast.showToast(
                          msg: 'Disponible ultérieurement'
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
                          textMontserrat('Caisse', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.deepOrangeAccent.withOpacity(0.7),
                            child: Icon(Icons.payments_outlined, size: 29,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.mediumImpact();
                      Fluttertoast.showToast(
                          msg: 'Disponible ultérieurement'
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
                          textMontserrat('Depenses', 12, Colors.black, TextAlign.center),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green.withOpacity(0.7),
                            child: Icon(Icons.account_balance_wallet_rounded, size: 29,color: Colors.white),
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
