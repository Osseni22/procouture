import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/widgets/default_app_bar.dart';

import '../../../widgets/custom_text.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Stock Articles', context),
      backgroundColor: Colors.grey[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent) : SizedBox(),
          const SizedBox(height: 20),
          Expanded(
              child: Container(
                //color: Colors.blue,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      headingRowHeight: 36,
                      border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent.withOpacity(0.2)),
                      // Datatable widget that have the property columns and rows.
                      columns: const [
                        // Set the name of the column
                        DataColumn(label: Text('Qté'),),
                        DataColumn(label: Text('Désignation'),),
                        DataColumn(label: Text('Estimation'),),
                      ],
                      rows: const [
                        // Set the values to the columns
                        DataRow(cells: [
                          DataCell(Text("1")),
                          DataCell(Text("Chemise tissu 1")),
                          DataCell(Text("500000 FCFA")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("2")),
                          DataCell(Text("Chemise tissu 2")),
                          DataCell(Text("500000 FCFA")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("3")),
                          DataCell(Text("Chemise tissu 3")),
                          DataCell(Text("500000 FCFA")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("4")),
                          DataCell(Text("Chemise tissu 4")),
                          DataCell(Text("500000 FCFA")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("5")),
                          DataCell(Text("Chemise tissu 5")),
                          DataCell(Text("500000 FCFA")),
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
                      Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Valeur du stock : ', 14, Colors.black, TextAlign.center)),
                      const SizedBox(width: 15,),
                      Container(alignment: Alignment.centerLeft, child: textOpenSans('3056000 FCA', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ]
            ),
          )
        ],
      ),
    );
  }
}
