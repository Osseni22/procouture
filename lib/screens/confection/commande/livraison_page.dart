import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';

import '../../../widgets/default_app_bar.dart';

class Livraison extends StatelessWidget {
  const Livraison({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Livraisons', context),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: Colors.green,),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) => Container(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWorkSans('Commande N°${index+1}', 17, Colors.black, TextAlign.start, fontWeight: FontWeight.bold),
                      const SizedBox(height: 4,),
                      textWorkSans('Client ${index+1}', 15, Colors.black, TextAlign.start,),
                      const SizedBox(height: 4,),
                      textWorkSans('A livrer le 30/03/2023', 15, Colors.black, TextAlign.start,),
                    ],
                  ),
                  InkWell(
                    onTap: (){print('OK');},
                    child: CircleAvatar(
                      radius: 21,
                      child: Icon(Icons.call_rounded),
                    ),
                  )
                ],
              ),
            ),
          ),
      )
    );
  }
}
