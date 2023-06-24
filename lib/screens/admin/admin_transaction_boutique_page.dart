import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/widgets/default_box_shadow.dart';

import '../../../widgets/custom_text.dart';
import '../../models/Atelier.dart';
import '../../models/Transactions.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/globals/global_var.dart';

class AdminTransactionBoutiquePage extends StatefulWidget {
  final Atelier atelier;
  const AdminTransactionBoutiquePage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminTransactionBoutiquePage> createState() => _AdminTransactionBoutiquePageState();
}

class _AdminTransactionBoutiquePageState extends State<AdminTransactionBoutiquePage> {

  List<Transaction> allTransactions = [];
  bool isLoading = false;

  TextEditingController dateTimeCtrl = TextEditingController();
  TextEditingController dateTimeCtrl2 = TextEditingController();
  final format = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    getAllTransactions();
  }


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
      appBar: myDefaultAppBar('Transactions boutique', context),
      //backgroundColor: Colors.grey[50],
      body: isLoading ? LinearProgressIndicator(backgroundColor: Colors.transparent,)
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: allTransactions.isNotEmpty? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Visibility(
                  visible: true,
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textMontserrat("Du", 13, Colors.black, TextAlign.center),
                        const SizedBox(width: 10,),
                        // Afficher la première date
                        Container(
                          alignment: Alignment.center,
                          width: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [kDefaultBoxShadow]
                            //border: Border.all(color: Colors.grey.withOpacity(0.5))
                          ),
                          child: DateTimeField(
                            resetIcon: null,
                            style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                            format: format,
                            controller: dateTimeCtrl,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Date début',
                                hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                            ),
                            onShowPicker: (context, currentValue) async {
                              return await showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10,),
                        textMontserrat("Au", 13, Colors.black, TextAlign.center),
                        const SizedBox(width: 10,),
                        // Afficher la deuxième date
                        Container(
                          alignment: Alignment.center,
                          width: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [kDefaultBoxShadow]
                          ),
                          child: DateTimeField(
                            resetIcon: null,
                            style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                            format: format,
                            controller: dateTimeCtrl2,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Date début',
                                hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey)
                            ),
                            onShowPicker: (context, currentValue) async {
                              return await showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15,),
                        // Afficher le bouton de recherche
                        Container(alignment: Alignment.center,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [kDefaultBoxShadow]
                          ),
                          child: IconButton(
                            onPressed: (){},
                            icon: Icon(CupertinoIcons.search, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        // Afficher le bouton de réinitialisation
                        Container(alignment: Alignment.center,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [kDefaultBoxShadow]
                            //border: Border.all(color: Colors.grey.withOpacity(0.5))
                          ),
                          child: IconButton(
                            onPressed: (){},
                            icon: Icon(CupertinoIcons.refresh, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: Container(
                      //color: Colors.blue,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowHeight: 42,
                          border: TableBorder.all(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(9)),
                          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          // Datatable widget that have the property columns and rows.
                          columns: [
                            // Set the name of the column
                            DataColumn(label: Text('Date'),),
                            DataColumn(label: Text('Libellé'),),
                            DataColumn(label: Text('Montant'),),
                            DataColumn(label: Text('Détails')/*IconButton(onPressed: (){}, icon: Icon(Icons.visibility))*/,),
                          ],
                          rows: allTransactions.map((transaction) {
                            return DataRow(cells: [
                              DataCell(Text(Globals.convertDateEnToFr(transaction.date!)!)),
                              DataCell(Text(transaction.libelle!)),
                              DataCell(Text("${NumberFormat('#,###', 'fr_FR').format(transaction.montant!)} ${widget.atelier.monnaie!.symbole}")),
                              DataCell(IconButton(onPressed: (){
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (ctx) => Container(
                                    alignment: Alignment.centerLeft,
                                    height: MediaQuery.of(context).size.width * 0.8,
                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //SizedBox(height: 3,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            textMontserrat("DETAILS DE LA TRANSACTION", 20, Colors.black, TextAlign.start, fontWeight: FontWeight.bold),
                                            GestureDetector(
                                              onTap:(){
                                                Navigator.pop(context);
                                              },
                                              child: CircleAvatar(
                                                radius: 22,
                                                backgroundColor: Colors.grey.shade300,
                                                child: Icon(Icons.close, color: Colors.black,),
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(),
                                        textMontserrat("Libellé:", 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700),
                                        textMontserrat(transaction.libelle!, 16, Colors.black, TextAlign.start,),
                                        textMontserrat("Date:", 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700),
                                        textMontserrat(Globals.convertDateEnToFr(transaction.date!)!, 16, Colors.black, TextAlign.start,),
                                        textMontserrat("Montant:", 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700),
                                        textMontserrat("${NumberFormat('#,###', 'fr_FR').format(transaction.montant!)} ${widget.atelier.monnaie!.symbole}", 16, Colors.black, TextAlign.start,),
                                        textMontserrat("Mode règlement:", 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700),
                                        textMontserrat(transaction.mode_reglement!.libelle!, 16, Colors.black, TextAlign.start,),
                                        //textMontserrat("Type transaction:", 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700),
                                        //textMontserrat(transaction.type_transaction!.libelle!, 16, Colors.black, TextAlign.start,),
                                        transaction.categorie_depense != null ? textMontserrat("Catégorie dépense:", 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700) : SizedBox(),
                                        transaction.categorie_depense != null ? textMontserrat(transaction.categorie_depense!.libelle!, 16, Colors.black, TextAlign.start) : SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              }, icon: Icon(Icons.visibility))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 10),
              ],
            ) : Center(child: Text('Aucune transaction')),
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

  Future<void> getAllTransactions() async {
    var request = http.Request('GET', Uri.parse(AdminRoutes.r_getTransactionBoutiqueUrl(widget.atelier.id!)));

    request.headers.addAll(Globals.apiHeaders);

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 200) {
      allTransactions.clear();
      late Transaction transaction;
      for(var trans in responseData['data']['transactions']){
        transaction = Transaction.fromJson(trans);
        allTransactions.add(transaction);
      }
      allTransactions.sort((a,b) => b.id!.compareTo(a.id!));
      //setState(() {});
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

}
