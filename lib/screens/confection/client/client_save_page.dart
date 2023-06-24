import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/models/Client.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:http/http.dart' as http;

import '../../../utils/globals/global_var.dart';

class ClientSavePage extends StatefulWidget {
  final String pageMode; final Client? client;
  ClientSavePage({Key? key, required this.pageMode, this.client}) : super(key: key);

  @override
  State<ClientSavePage> createState() => _ClientSavePageState();
}

class _ClientSavePageState extends State<ClientSavePage> {

  /// CONTROLLERS
  TextEditingController nomCtrl = TextEditingController();
  TextEditingController telephone1Ctrl = TextEditingController();
  TextEditingController telephone2Ctrl = TextEditingController();
  TextEditingController villeCtrl = TextEditingController();
  TextEditingController adresseCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  /// LOADING STATE
  var isLoading = false;

  @override
  void initState() {
    if (widget.pageMode == 'M') {
      nomCtrl.text = widget.client!.nom!;
      widget.client?.telephone1 != null ? telephone1Ctrl.text = widget.client!.telephone1! : telephone1Ctrl.text = '';
      widget.client!.telephone2 != null ? telephone2Ctrl.text = widget.client!.telephone2! : telephone2Ctrl.text = '';
      widget.client!.ville != null ? villeCtrl.text = widget.client!.ville! : villeCtrl.text = '';
      widget.client!.adresse != null ? adresseCtrl.text = widget.client!.adresse! : adresseCtrl.text = '';
      widget.client!.email != null ? emailCtrl.text = widget.client!.email! : emailCtrl.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar('Fiche Client', context),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: nomCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Nom',
                              hintStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: telephone1Ctrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.local_phone),
                            hintText: 'Telephone 1',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: telephone2Ctrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(CupertinoIcons.phone_fill),
                              hintText: 'Telephone 2',
                              hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: villeCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.location_city_rounded),
                            hintText: 'Ville',
                            hintStyle: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: adresseCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.location_on_rounded),
                            hintText: 'Adresse',
                            hintStyle: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.alternate_email),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                /// BOUTON DE VALIDATION
                GestureDetector(
                  onTap: () {
                    /*if (emailCtrl.text.isNotEmpty && !EmailValidator.validate(emailCtrl.text)) {
                      Fluttertoast.showToast(msg: 'Email incorrect');
                      return;
                    }*/
                    if(nomCtrl.text.isEmpty){
                      Fluttertoast.showToast(msg: 'Le nom du client est requis');
                      return;
                    }
                    if(telephone1Ctrl.text.isEmpty){
                      Fluttertoast.showToast(msg: 'Le N° de telephone 1 du client est requis');
                      return;
                    }
                    if (widget.pageMode == 'A') {
                      createClient(nomCtrl.text.toString(), adresseCtrl.text.toString(), villeCtrl.text.toString(),
                          telephone1Ctrl.text.toString(), telephone2Ctrl.text.toString(),
                          emailCtrl.text.toString());
                    } else {
                      updateClient(nomCtrl.text, adresseCtrl.text, villeCtrl.text,
                          telephone1Ctrl.text, telephone2Ctrl.text,
                          emailCtrl.text
                      );
                    }
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: kProcouture_green,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 10)
                            )
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textMontserrat(
                            widget.pageMode == 'A' ? 'Valider' : 'Modifier', 18,
                            Colors.white, TextAlign.center,
                            fontWeight: FontWeight.w500,),
                          isLoading
                              ? const SizedBox(width: 10,)
                              : const SizedBox(),
                          isLoading ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                          ) : const SizedBox(),
                        ],
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createClient(String nom, String adresse, String ville,
      String telephone1, String telephone2, String email) async {

    String bearerToken = 'Bearer ${CnxInfo.token!}';
    Map<String, String> data = {
      "nom": nom,
      "adresse": adresse,
      "ville": ville,
      "telephone1": telephone1,
      "telephone2": telephone2,
      "email": email,
    };
    var headers = {
      'Accept':'application/json',
      'Content-Type':'application/json',
      'Authorization': bearerToken,
    };

    var request = http.MultipartRequest('POST', Uri.parse(r_client));
    request.fields.addAll(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);

    //print(response.stream.bytesToString());

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: responseData['messages']);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

  Future<void> updateClient(String nom, String adresse, String ville,
      String telephone1, String telephone2, String email) async {

    String bearerToken = "Bearer ${CnxInfo.token!}";

    Map<String, String> data = {
      "nom": nom,
      "adresse": adresse,
      "ville": ville,
      "telephone1": telephone1,
      "telephone2": telephone2,
      "email": email,
    };

    var headers = {
      "Accept" : "application/json",
      "Content-Type" : "application/json",
      "Authorization" : bearerToken,
    };

    final response = await http.put(
      Uri.parse('$r_client/${widget.client!.id!.toString()}'),
      headers: headers,
      body: jsonEncode(data),
    );

    final jsonDecoder = JsonDecoder();
    final jsonMap = jsonDecoder.convert(response.body);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: jsonMap['messages']);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: jsonMap['messages']);
    }

  }

  void progressIndicator(bool value) {
    if (value) {
      setState(() { isLoading = true; });
    } else {
      setState(() { isLoading = false; });
    }
  }

}
