import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';

class MonComptePage extends StatelessWidget {
  const MonComptePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Fond_compte_utilisateur.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          height: height,
          width: width,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,)),
                    textLato('Mon Compte', 20, Colors.white, TextAlign.center),
                    Container(width: 30,),
                  ]
              ),
              const SizedBox(height: 60),
              Container(
                width: width * 0.8,
                height: 490,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: AssetImage('assets/images/appstore.png'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      SizedBox(height: 15,),
                      // Atelier
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.home, color: Colors.white,),
                          SizedBox(width: 10,),
                          textMontserrat('Osseni Couture Inter', 14, Colors.white, TextAlign.left)
                        ],
                      ),
                      SizedBox(height: 15,),
                      // Pays
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.flag, color: Colors.white,),
                          SizedBox(width: 10,),
                          textMontserrat('Côte d\'Ivoire', 14, Colors.white, TextAlign.left)
                        ],
                      ),
                      SizedBox(height: 15,),
                      // Monnaie
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.payments_outlined, color: Colors.white,),
                          SizedBox(width: 10,),
                          textMontserrat('FCFA', 14, Colors.white, TextAlign.left)
                        ],
                      ),
                      SizedBox(height: 15,),
                      // Adresse
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.location_solid, color: Colors.white,),
                          SizedBox(width: 10,),
                          textMontserrat('Grand-Bassam', 14, Colors.white, TextAlign.left)
                        ],
                      ),
                      SizedBox(height: 15,),
                      // Telephone 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.phone_circle_fill, color: Colors.white,),
                          SizedBox(width: 10,),
                          textMontserrat('01 02 03 04 05', 14, Colors.white, TextAlign.left)
                        ],
                      ),
                      SizedBox(height: 15,),
                      // Telephone 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.phone_circle, color: Colors.white,),
                          SizedBox(width: 10,),
                          textMontserrat('06 07 08 09 00', 14, Colors.white, TextAlign.left)
                        ],
                      ),
                      SizedBox(height: 15,),
                      // E-mail
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.mail_solid, color: Colors.white,),
                          SizedBox(width: 10,),
                          textMontserrat('ossenicoutureinter@gmail.com', 14, Colors.white, TextAlign.left)
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: ElevatedButton(
                          //style: ElevatedButton.styleFrom(shape: OutlinedBorder()),
                          onPressed: (){},
                          child: textMontserrat('Modifier Informations', 13, Colors.white, TextAlign.center),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
