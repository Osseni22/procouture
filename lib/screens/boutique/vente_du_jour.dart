import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';

import '../../../widgets/default_app_bar.dart';

class VenteDuJour extends StatelessWidget {
  const VenteDuJour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myDefaultAppBar('Ventes du jour', context),
        body: ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: Colors.green,),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) => Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWorkSans('Vente N°${index+1}', 20, Colors.black, TextAlign.start, fontWeight: FontWeight.bold),
                  const SizedBox(height: 8,),
                  textWorkSans('Client ${index+1}', 18, Colors.black, TextAlign.start,),
                  const SizedBox(height: 8,),
                  textWorkSans('Montant TTC 150 000 FCFA', 18, Colors.black, TextAlign.start,),
                ],
              ),
            ),
          ),
        )
    );
  }
}
