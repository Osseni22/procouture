import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/screens/confection/transaction/etat_caisse_page.dart';

import '../../../widgets/default_app_bar.dart';
import '../../../widgets/default_box_shadow.dart';

class CaisseResultatMensuel extends StatefulWidget {
  const CaisseResultatMensuel({Key? key}) : super(key: key);

  @override
  State<CaisseResultatMensuel> createState() => _CaisseResultatMensuelState();
}

class _CaisseResultatMensuelState extends State<CaisseResultatMensuel> {

  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width * 0.8;
    const width = 280.0;
    return Scaffold(
      appBar: myDefaultAppBar('Résultat mensuel',context),
      body: Center(
        child: Container(
          height: width-40,
          width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [kDefaultBoxShadow]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                alignment: Alignment.center,
                child: textOpenSans('En Décembre 2023', 17, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
              ),
              Container(
                alignment: Alignment.center,
                //height: (width/3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Total Recettes : ', 17, Colors.black, TextAlign.end)),
                        const SizedBox(width: 15,),
                        Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 17, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Total Dépenses : ', 17, Colors.black, TextAlign.end)),
                        const SizedBox(width: 15,),
                        Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 17, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Solde : ', 17, Colors.black, TextAlign.end)),
                        const SizedBox(width: 15,),
                        Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 17, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //height: (width/3),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: ElevatedButton(
                        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => EtatCaisse()));},
                        child: textOpenSans('Voir détails de la caisse', 14, Colors.white, TextAlign.center),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(onPressed: (){}, child: textOpenSans('Nouvelle Recette', 12, Colors.black, TextAlign.center)),
                          SizedBox(width: 7),
                          OutlinedButton(onPressed: (){}, child: textOpenSans('Nouvelle Depense', 12, Colors.black, TextAlign.center)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
