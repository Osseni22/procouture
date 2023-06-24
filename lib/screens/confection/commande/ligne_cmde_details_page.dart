import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';

import '../../../models/LigneCommande.dart';

class LigneCmdeDetailsPage extends StatelessWidget {
  final LigneCommande ligneCommande;
  const LigneCmdeDetailsPage({Key? key, required this.ligneCommande}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myDefaultAppBar('Détails du modèle commande', context, textSize: 15),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: imageWidth * 0.8,
                  height: imageWidth * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [kDefaultBoxShadow],
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: ligneCommande.image_av == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : NetworkImage(ligneCommande.image_av!),
                    )
                  ),
                ),
                SizedBox(height: 30,),
                textRaleway(ligneCommande.product!.libelle!, 20, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textMontserrat('Quantité: ', 16, Colors.black, TextAlign.center,),
                    SizedBox(width: 5,),
                    textMontserrat(ligneCommande.qte.toString(), 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textMontserrat('Prix total: ', 16, Colors.black, TextAlign.center,),
                    SizedBox(width: 5,),
                    textMontserrat(NumberFormat('#,###', 'fr_FR').format(ligneCommande.prix), 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textMontserrat('Quantité terminée: ', 16, Colors.black, TextAlign.center,),
                    SizedBox(width: 5,),
                    textMontserrat(ligneCommande.qte_confection_done.toString(), 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textMontserrat('Quantité retirée: ', 16, Colors.black, TextAlign.center,),
                    SizedBox(width: 5,),
                    textMontserrat(ligneCommande.qte_retrait.toString(), 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  children: [
                    textMontserrat('Description: ', 16, Colors.black, TextAlign.center,),
                    SizedBox(width: 5,),
                    textMontserrat(ligneCommande.description != null ? ligneCommande.description! : '', 12, Colors.grey, TextAlign.center,),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
