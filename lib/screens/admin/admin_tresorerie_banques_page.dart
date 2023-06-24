import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/models/Banque.dart';
import 'package:procouture/screens/admin/admin_transaction_banque_page.dart';
import 'package:procouture/screens/admin/admin_user_save_page.dart';
import 'package:procouture/screens/admin/admin_banque_save_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/widgets/default_box_shadow.dart';

import '../../components/message_box.dart';
import '../../models/Atelier.dart';
import '../../models/User.dart';
import '../../services/api_routes/routes.dart';
import '../../widgets/default_app_bar.dart';

class AdminTresorerieBanquePage extends StatefulWidget {
  Atelier? atelier;
  AdminTresorerieBanquePage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminTresorerieBanquePage> createState() => _AdminTresorerieBanquePageState();
}

class _AdminTresorerieBanquePageState extends State<AdminTresorerieBanquePage> {

  bool isLoading = false;
  bool isExpanded = false;
  bool isOK = false;
  int bankId = 0;

  List<Banque> allBanques = [];

  @override
  void initState() {
    getAllBanques();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar('Banques',context),
      body: isLoading ? LinearProgressIndicator(backgroundColor: Colors.transparent,)
          : Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
          child: Column(
          children: [
            SizedBox(height: 10,),
            Expanded(
                child: allBanques.isNotEmpty ?
                Container(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: allBanques.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTransactionBanquePage(atelier: widget.atelier!, banque: allBanques[index])));
                          },
                          child: Container(
                            height: 85,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                boxShadow: [kDefaultBoxShadow]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textLato(allBanques[index].libelle!, 19, Colors.black, TextAlign.left),
                                        textWorkSans("Solde : ${NumberFormat('#,###', 'fr_FR').format(allBanques[index].solde!)} ${widget.atelier!.monnaie!.symbole}", 16, Colors.grey, TextAlign.left,fontWeight: FontWeight.w600),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTransactionBanquePage(atelier: widget.atelier!, banque: allBanques[index])));
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 80,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      //padding: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: textMontserrat("Voir", 13, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ) : Center(child: Text('Aucune banque enregistrée'),)
            )
          ],
        ),
      ),
    );
  }

  Future<void> getAllBanques() async {

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(AdminRoutes.r_getBanquesUrl(widget.atelier!.id!)),
      headers: Globals.apiHeaders,
    );
    loadingProgress(false);

    allBanques.clear();
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      late Banque banque;
      for (int i = 0; i < responseBody['data']['banques'].length; i++) { // Get all users
        banque = Banque.fromJson(responseBody['data']['banques'][i]);
        allBanques.add(banque);
      }
    }
    setState(() {});
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

}
