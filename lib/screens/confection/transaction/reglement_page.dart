import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/models/Commande.dart';
import 'package:procouture/screens/confection/transaction/reglement_save_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/widgets/default_box_shadow.dart';

import '../../../models/Transactions.dart';
import '../../../services/api_routes/routes.dart';
import '../../../widgets/custom_text.dart';

class ReglementPage extends StatefulWidget {
  final Commande commande;
  ReglementPage({Key? key, required this.commande}) : super(key: key);

  @override
  State<ReglementPage> createState() => _ReglementPageState();
}

class _ReglementPageState extends State<ReglementPage> {

  bool isLoading = false;
  List<Reglement> allReglements = [];
  Commande? commande;



  @override
  void initState() {
    getReglements();
    getCommande();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double amountBox = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.1,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,),onPressed: (){ Navigator.pop(context);},),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textOpenSans('Règlement client', 17, Colors.black, TextAlign.center),
            textOpenSans("${widget.commande.client}", 10, Colors.black, TextAlign.center),
          ],
        ),
      ),
      body: !isLoading ?
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(alignment: AlignmentDirectional.centerStart,child: textOpenSans(commande != null ? 'Commande N°${commande!.id} ' : '', 18, Colors.green, TextAlign.center,fontWeight: FontWeight.w600)),
                    Container(alignment: AlignmentDirectional.centerEnd,child: textOpenSans(commande != null ? '(${commande!.ref})' : '', 18, Colors.blueGrey, TextAlign.center,)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6,),
            Container(
              //color: Colors.blue,
              height: 100,
              width: MediaQuery.of(context).size.width * 0.98,
              alignment: Alignment.center,
              //color: Colors.blue,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(width: 150, alignment: AlignmentDirectional.centerStart, child: textOpenSans('Montant TTC : ', 18, Colors.black, TextAlign.end)),
                      const SizedBox(width: 5,),
                      Container(width: amountBox,alignment: Alignment.centerLeft, child: textOpenSans(commande != null ? "${NumberFormat('#,###', 'fr_FR').format(widget.commande.montant_ttc)} ${CnxInfo.symboleMonnaie}" : '', 18, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(width: 150, alignment: AlignmentDirectional.centerStart, child: textOpenSans('Montant réglé : ', 18, Colors.black, TextAlign.end)),
                      const SizedBox(width: 5,),
                      Container(width: amountBox, alignment: Alignment.centerLeft, child: textOpenSans(commande != null ? "${NumberFormat('#,###', 'fr_FR').format(widget.commande.montant_recu!)} ${CnxInfo.symboleMonnaie}": '', 18, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(width: 150, alignment: AlignmentDirectional.centerStart, child: textOpenSans('Montant restant : ', 18, Colors.black, TextAlign.end)),
                      const SizedBox(width: 5,),
                      Container(width: amountBox, alignment: Alignment.centerLeft, child: textOpenSans(commande != null ? "${NumberFormat('#,###', 'fr_FR').format(widget.commande.montant_ttc! - widget.commande.montant_recu!)} ${CnxInfo.symboleMonnaie}" : '', 18, Colors.black, TextAlign.center,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
                child: allReglements.isNotEmpty ? ListView.builder(
                  itemCount: allReglements.length,
                    itemBuilder: (context, int index) => Container(
                      height: 80,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [kDefaultBoxShadow]
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
                                textOpenSans(Globals.convertDateEnToFr(allReglements[index].transaction!.date!)!, 13, Colors.black, TextAlign.left),
                                textOpenSans(allReglements[index].transaction!.mode_reglement!.libelle!, 13, kProcouture_green, TextAlign.left, fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                          // Afficher le montant
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              //width: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  textOpenSans("${NumberFormat('#,###', 'fr_FR').format(allReglements[index].transaction!.montant)} ${CnxInfo.symboleMonnaie}", 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w700),
                                  textMontserrat('${allReglements[index].ref}', 13, Colors.grey.shade600, TextAlign.start, fontWeight: FontWeight.w400),
                                ],
                              ),
                            ),
                          ),
                          // Afficher bouton suppression
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: IconButton(
                                icon: Icon(CupertinoIcons.delete_solid, color: Colors.black, size: 18,),
                                onPressed: (){},
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ): Center(child: Text('Aucun règlement enregistré', style: TextStyle(color: Colors.black45),)),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ) : const LinearProgressIndicator(backgroundColor: Colors.transparent,),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_)=> ReglementSavePage(commande: commande!)));
          getCommande();
          getReglements();
        },
        child: Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void loadingProgress(bool bool) {
    if(bool){
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getReglements() async {

    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

    loadingProgress(true);
    final response = await http.get(
      Uri.parse("$r_reglement/${widget.commande.id!}"),
      headers: myHeaders,
    );
    loadingProgress(false);

    if(response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      allReglements.clear();
      for(int i = 0; i < responseBody['data']['reglements'].length; i++) { // Get all commandes
        Reglement reglement = Reglement.fromJson(responseBody['data']['reglements'][i]);
        allReglements.add(reglement);
      }
      allReglements.sort((a, b) => b.id!.compareTo(a.id!));
    } else {
      final responseBody = jsonDecode(response.body);
      //print(responseBody);
      Fluttertoast.showToast(msg: '${responseBody['messages']}');
    }

  }
  Future<void> getCommande() async {

    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_commande),
      headers: myHeaders,
    );
    loadingProgress(false);

    List<Commande> myCommandes = [];
    late Commande cmde;
    if(response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      for(int i = 0; i < responseBody['data']['commandes'].length; i++) { // Get all commandes
        cmde = Commande.fromJson(responseBody['data']['commandes'][i]);
        myCommandes.add(cmde);
      }
      for(var cde in myCommandes){
        if(cde.id == widget.commande.id){
          commande = cde;
        }
      }
    } else {
      final responseBody = jsonDecode(response.body);
      Fluttertoast.showToast(msg: '${responseBody['messages']}');
    }

  }

}
