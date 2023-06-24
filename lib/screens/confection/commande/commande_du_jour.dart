import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/utils/globals/global_var.dart';

import '../../../models/Commande.dart';
import '../../../widgets/default_app_bar.dart';

class CommandeDuJour extends StatelessWidget {
  final List<Commande> commandes;
  const CommandeDuJour({Key? key, required this.commandes}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myDefaultAppBar('Commandes du jour', context),
        body: ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Colors.grey.shade300,),
          itemCount: commandes.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: (){

            },
            child: Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWorkSans("Commande N°${commandes[index].id} (ref:${commandes[index].ref})", 17, Colors.black, TextAlign.start, fontWeight: FontWeight.bold),
                    const SizedBox(height: 4,),
                    textWorkSans("Client ${commandes[index].client}", 15, Colors.black, TextAlign.start,),
                    const SizedBox(height: 4,),
                    textWorkSans("A livrer le ${Globals.convertDateEnToFr(commandes[index].date_prev_livraison!)}", 15, Colors.black, TextAlign.start,),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
