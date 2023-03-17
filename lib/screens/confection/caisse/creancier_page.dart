import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/widgets/default_app_bar.dart';

import '../../../widgets/custom_text.dart';

class CreancierPage extends StatelessWidget {
  const CreancierPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Créanciers', context),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Expanded(
                child: Container(
                  //color: Colors.blue,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                        headingRowHeight: 30,
                        border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.2)),
                        // Datatable widget that have the property columns and rows.
                        columns: const [
                          // Set the name of the column
                          DataColumn(label: Text('Client'),),
                          DataColumn(label: Text('Montant'),),
                        ],
                        rows: const [
                          // Set the values to the columns
                          DataRow(cells: [
                            DataCell(Text("Le client qui doit 1 Osseni Abdel Aziz")),
                            DataCell(Text("50000 FCFA")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("Le client qui doit 2")),
                            DataCell(Text("10000 FCFA")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("Le client qui doit 3")),
                            DataCell(Text("250000 FCFA")),
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
                        Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Total Créances : ', 14, Colors.black, TextAlign.center)),
                        const SizedBox(width: 15,),
                        Container(alignment: Alignment.centerLeft, child: textOpenSans('205000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
