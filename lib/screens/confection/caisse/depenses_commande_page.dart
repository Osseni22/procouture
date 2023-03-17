import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_text.dart';

class DepenseCommandePage extends StatefulWidget {
  const DepenseCommandePage({Key? key}) : super(key: key);

  @override
  State<DepenseCommandePage> createState() => _DepenseCommandePageState();
}

class _DepenseCommandePageState extends State<DepenseCommandePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.1,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,),onPressed: (){ Navigator.pop(context);},),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textOpenSans('Dépenses commandes', 17, Colors.black, TextAlign.center),
            textOpenSans('Osseni Abdel Aziz', 10, Colors.black, TextAlign.center),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Commande N°1', 18, Colors.green, TextAlign.center,fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Montant TTC : ', 17, Colors.black, TextAlign.end)),
                const SizedBox(width: 15,),
                Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 17, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Total dépenses : ', 17, Colors.black, TextAlign.end)),
                const SizedBox(width: 15,),
                Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 17, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Bénéfice : ', 17, Colors.black, TextAlign.end)),
                const SizedBox(width: 15,),
                Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 17, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
                child: ListView.builder(
                    itemCount: 12,
                    itemBuilder: (context, int index) => Container(
                      height: 65,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Afficher Date et mode de règlement
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                textOpenSans('31/12/2023', 14, Colors.black, TextAlign.left),
                                textOpenSans('Espèces', 14, Colors.black, TextAlign.left),
                              ],
                            ),
                          ),
                          // Afficher le montant
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 150,
                            child: textOpenSans('2500000 FCFA', 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700),
                          ),
                          // Afficher bouton suppression
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: IconButton(
                                icon: Icon(CupertinoIcons.delete_solid, color: Colors.black,),
                                onPressed: (){},
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                )
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
