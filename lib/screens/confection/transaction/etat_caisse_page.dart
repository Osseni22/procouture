import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/widgets/default_app_bar.dart';

import '../../../widgets/custom_text.dart';

class EtatCaisse extends StatefulWidget {
  const EtatCaisse({Key? key}) : super(key: key);

  @override
  State<EtatCaisse> createState() => _EtatCaisseState();
}

class _EtatCaisseState extends State<EtatCaisse> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
// Step 3
  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.landscapeRight,
      //DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      //DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Etat de la caisse', context),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textMontserrat("Du", 13, Colors.black, TextAlign.center),
                  const SizedBox(width: 10,),
                  // Afficher la première date
                  GestureDetector(
                    onTap:() {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        //border: Border.all(color: Colors.grey.withOpacity(0.5))
                      ),
                      child: textMontserrat("31-12-2023", 15, Colors.black, TextAlign.center),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  textMontserrat("Au", 13, Colors.black, TextAlign.center),
                  const SizedBox(width: 10,),
                  // Afficher la deuxième date
                  GestureDetector(
                    onTap:() async {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        //border: Border.all(color: Colors.grey.withOpacity(0.5))
                      ),
                      child: textMontserrat("31-12-2023", 15, Colors.black, TextAlign.center),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  // Afficher le bouton de recherche
                  Container(alignment: Alignment.center,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      //border: Border.all(color: Colors.grey.withOpacity(0.5))
                    ),
                    child: IconButton(
                      onPressed: (){},
                      icon: Icon(CupertinoIcons.search, color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Container(
                  //color: Colors.blue,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      headingRowHeight: 30,
                      border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.green.withOpacity(0.2)),
                      // Datatable widget that have the property columns and rows.
                        columns: const [
                          // Set the name of the column
                          DataColumn(label: Text('Date'),),
                          DataColumn(label: Text('Recettes'),),
                          DataColumn(label: Text('Dépenses'),),
                          DataColumn(label: Text('Libelle'),),
                        ],
                        rows: const [
                          // Set the values to the columns
                          DataRow(cells: [
                            DataCell(Text("31-12-2023")),
                            DataCell(Text("2500000 FCFA")),
                            DataCell(Text("0 FCFA")),
                            DataCell(Text("Règlement Espèces du client 1")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("31-12-2023")),
                            DataCell(Text("2100000 FCFA")),
                            DataCell(Text("0 FCFA")),
                            DataCell(Text("Règlement Espèces du client 1")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("31-12-2023")),
                            DataCell(Text("0 FCFA")),
                            DataCell(Text("35000 FCFA")),
                            DataCell(Text("Paiement en espèces de la commission d'un employé")),
                          ]),
                        ]
                    ),
                  ),
                )
            ),
            const SizedBox(height: 10),
            Container(
              height: 25,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Total Recettes : ', 14, Colors.black, TextAlign.center)),
                      const SizedBox(width: 3,),
                      Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(width: 6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Total Dépenses : ', 14, Colors.black, TextAlign.center)),
                      const SizedBox(width: 3,),
                      Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(width: 6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Solde : ', 14, Colors.black, TextAlign.center)),
                      const SizedBox(width: 3,),
                      Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
