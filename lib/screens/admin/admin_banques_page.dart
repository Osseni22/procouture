import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/models/Banque.dart';
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

class AdminBanquesPage extends StatefulWidget {
  Atelier? atelier;
  AdminBanquesPage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminBanquesPage> createState() => _AdminBanquesPageState();
}

class _AdminBanquesPageState extends State<AdminBanquesPage> {

  bool isLoading = false;
  bool isExpanded = false;
  bool isOK = false;
  int bankId = 0;

  List<Banque> allBanques = [];

  TextEditingController controller = TextEditingController();

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
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  if(await msgBoxYesNo('Confirmation ', 'Supprimer cette banque ?', context)) {
                                  } else {};
                                },
                                icon: CupertinoIcons.delete,
                                label: 'Supprimer',
                                backgroundColor: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(15),
                              )
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              controller.text = allBanques[index].libelle!;
                              bankId = allBanques[index].id!;

                              isOK = false;
                              if(await addBanque("M")){
                                getAllBanques();
                              }

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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ) : Center(child: Text('Aucune Banque enregistrée'),)
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          isOK = false;
          if(await addBanque("A")){
            //createBanque(controller.text);
            getAllBanques();
          }
        },
        backgroundColor: kProcouture_green,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  // CREATE A BANK
  Future<void> createBanque(String libelle) async {
    var request = http.MultipartRequest('POST', Uri.parse(AdminRoutes.r_getBanquesUrl(widget.atelier!.id!)));
    request.fields.addAll({
      'libelle': libelle
    });
    request.headers.addAll(Globals.apiHeaders);

    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }
  // UPDATE A BANK
  Future<void> updateBanque(String libelle, int id) async {

    var request = http.Request('PUT', Uri.parse("${AdminRoutes.r_getBanquesUrl(widget.atelier!.id!)}/$id"));
    request.body = json.encode({
      "libelle": libelle
    });
    request.headers.addAll(Globals.apiHeaders);

    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
    else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }

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

  Future<bool> addBanque(String pageMode) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une banque'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(13.0),
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            onChanged: (value) {
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                isOK = false;
                controller.text = '';
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: pageMode == 'A' ? Text('Ajouter') : Text('Modifier'),
              onPressed: () {
                if(controller.text.isEmpty){
                  Fluttertoast.showToast(msg: 'Le champ est vide');
                  return;
                }
                isOK = true;
                if(pageMode == 'A'){
                  createBanque(controller.text);
                } else {
                  updateBanque(controller.text, bankId);
                  //getAllBanques();
                }
                controller.text = '';
                //setState(() {});
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

}
