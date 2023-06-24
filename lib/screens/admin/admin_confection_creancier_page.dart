import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_text.dart';
import '../../models/Atelier.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/globals/global_var.dart';

class AdminConfectionCreancierPage extends StatefulWidget {
  final Atelier atelier;
  const AdminConfectionCreancierPage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminConfectionCreancierPage> createState() => _AdminConfectionCreancierPageState();
}

class _AdminConfectionCreancierPageState extends State<AdminConfectionCreancierPage> {

  bool isLoading = false;
  List<Map<String, dynamic>> allCreanciers = [];
  int totalCreance = 0;

  @override
  void initState() {
    getCreanciers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Liste des créanciers', context),
      backgroundColor: Colors.grey[100],
      body: isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Expanded(
              child: Container(
                //color: Colors.blue,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      headingRowHeight: 42,
                      border: TableBorder.all(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(9)),
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                      // Datatable widget that have the property columns and rows.
                      columns: const [
                        // Set the name of the column
                        DataColumn(label: Text('Client'),),
                        DataColumn(label: Text('Telephone'),),
                        DataColumn(label: Text('Montant'),),
                      ],
                      rows: allCreanciers.map((data) => DataRow(
                          cells: [
                            DataCell(Text(data['nom'].toString())),
                            DataCell(Text(data['telephone1'].toString())),
                            DataCell(Text("${NumberFormat('#,###', 'fr_FR').format(data['montant_creance'])} ${widget.atelier.monnaie!.symbole}")),
                          ])
                      ).toList()
                  ),
                ),
              )
          ),
          const SizedBox(height: 10),
          Container(
            height: 30,
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans('Total Créances: ', 16, Colors.black, TextAlign.center)),
                      const SizedBox(width: 2,),
                      Container(alignment: Alignment.centerLeft, child: textOpenSans("${NumberFormat('#,###', 'fr_FR').format(totalCreance)} ${widget.atelier.monnaie!.symbole}", 16, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ]
            ),
          )
        ],
      ),
    );
  }

  void loadingProgress(bool value) {
    if (value) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCreanciers() async {
    var request = http.Request('GET', Uri.parse(AdminRoutes.r_getTransactionConfectionCreancierUrl(widget.atelier.id!)));

    request.headers.addAll(Globals.apiHeaders);

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 200) {

      for(int i=0; i < responseData['data']['creanciers'].length; i++){
        Map<String, dynamic> data = {
          "nom": responseData['data']['creanciers'][i]['nom'],
          "telephone1": responseData['data']['creanciers'][i]['telephone1'],
          "montant_creance": responseData['data']['creanciers'][i]['montant_creance']
        };
        allCreanciers.add(data);
      }
      print(allCreanciers);
      totalCreance = responseData['data']['total_creance'];
      setState(() {});
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

}
