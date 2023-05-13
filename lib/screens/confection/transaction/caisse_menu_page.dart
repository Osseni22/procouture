import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:procouture/screens/confection/transaction/caisse_resultat_mensuel_page.dart';
import 'package:procouture/screens/confection/transaction/creancier_page.dart';
import 'package:procouture/screens/confection/transaction/depense_page.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';

class MenuCaise extends StatelessWidget {
  const MenuCaise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: myDefaultAppBar('Trésorerie', context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){/*Navigator.push(context, MaterialPageRoute(builder: (_) => CaisseResultatMensuel()));*/},
                child: Container(
                  height: 120,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [kDefaultBoxShadow]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  [
                        textRaleway('Solde général :', 17, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                        SizedBox(height: 10,),
                        textLato('250 000 000 F CFA', 20, Colors.black, TextAlign.center, fontWeight: FontWeight.w800),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){/*Navigator.push(context, MaterialPageRoute(builder: (_) => CaisseResultatMensuel()));*/},
                child: Container(
                  height: 120,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [kDefaultBoxShadow]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.payments, color: Colors.white,),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: width-90,
                            child: textMontserrat('Solde caisse', 15, Colors.black, TextAlign.center)
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){/*Navigator.push(context, MaterialPageRoute(builder: (_) => DepensePage()));*/},
                child: Container(
                  height: 120,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                      boxShadow: [kDefaultBoxShadow]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.account_balance_rounded, color: Colors.white,),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          //color: Colors.blue,
                          width: width-90,
                            child: textMontserrat('Solde banque', 15, Colors.black, TextAlign.center)
                        )
                      ],
                    ),
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
