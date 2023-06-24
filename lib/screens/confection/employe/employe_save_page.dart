import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/models/Employe.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:http/http.dart' as http;

import '../../../models/Poste.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';

class EmployeSave extends StatefulWidget {
  final String pageMode; final Employe? employe; final List<Poste> postes;
  EmployeSave({Key? key, this.employe, required this.postes, required this.pageMode}) : super(key: key);

  @override
  State<EmployeSave> createState() => _EmployeSaveState();
}

class _EmployeSaveState extends State<EmployeSave> {

  bool isLoading = false;
  //RegExp regex = RegExp(r"#^(?:\+\d{1,3}\s?)?(?:\d{8,11})$#");

  TextEditingController ctrlNom = TextEditingController();
  TextEditingController ctrlTelephone = TextEditingController();
  TextEditingController ctrlAdresse = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlSalaire = TextEditingController();

  // Tous les postes
  List<Poste> allPostes = [];
  Poste? selectedPoste;

  @override
  void initState() {

    if(widget.pageMode == 'M'){ // MODE MODIFICATION
      getEmployeInfo(widget.employe!);
      ctrlNom.text = widget.employe!.nom!;
      widget.employe?.telephone != null ? ctrlTelephone.text = widget.employe!.telephone! : ctrlTelephone.text = "";
      widget.employe?.adresse != null ? ctrlAdresse.text = widget.employe!.adresse! : ctrlAdresse.text = "";
      widget.employe?.email != null ? ctrlEmail.text = widget.employe!.email! : ctrlEmail.text = "";
      widget.employe?.salaire != null ? ctrlSalaire.text = widget.employe!.salaire.toString() : ctrlSalaire.text = "";
      //widget.employe?.telephone != null ? ctrlTelephone.text = widget.employe!.nom! : ctrlTelephone.text = "";
    } else { // MODE AJOUT
      getEmployeInfo(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Fiche Employe', context),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30,horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  padding:  EdgeInsets.all(5),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrlNom,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  hintText: 'Nom',
                                  hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            textMontserrat("*", 21, Colors.red, TextAlign.start)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: ctrlTelephone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            border: InputBorder.none,
                            hintText: 'Telephone',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
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
                          controller: ctrlEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            border: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: ctrlAdresse,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on_rounded),
                            border: InputBorder.none,
                            hintText: 'Adresse',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: ctrlSalaire,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.attach_money),
                            border: InputBorder.none,
                            hintText: 'Salaire',
                            hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                           // border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20,),
                            Expanded(
                              child: DropdownButton<Poste>(
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: textWorkSans('Selectionner le poste',14,Colors.grey,TextAlign.left),
                                value: selectedPoste,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: allPostes.map((Poste itemsValue) {
                                  return DropdownMenuItem(
                                    value: itemsValue,
                                    child: textMontserrat(itemsValue.libelle!,14,Colors.black, TextAlign.left),
                                  );
                                }).toList(),
                                onChanged: (Poste? newValue) {
                                  setState(() {
                                    selectedPoste = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                GestureDetector(
                  onTap: (){
                    if(widget.pageMode == "A"){
                      createEmploye();
                    } else {
                      updateEmploye();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: double.infinity,
                    padding:  EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: kProcouture_green,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          /*BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 10)
                          )*/
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textMontserrat(
                          widget.pageMode == 'A' ? 'Valider' : 'Modifier', 16,
                          Colors.white, TextAlign.center,
                          fontWeight: FontWeight.w500,
                        ),
                        isLoading
                            ? const SizedBox(width: 10,)
                            : const SizedBox(),
                        isLoading ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.0),
                        ) : const SizedBox()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startLoading(){
    setState(() {
      isLoading = true;
    });
  }
  void endLoading(){
    setState(() {
      isLoading = false;
    });
  }

  void getPoste(Employe employe){
    for(var poste in widget.postes){
      if(employe.poste_id == poste.id){
        selectedPoste = poste;
      }
    }
    selectedPoste = null;
  }

  void getEmployeInfo(Employe? employe){
    if(widget.pageMode == 'A'){
      setState(() {
        allPostes = widget.postes;
        selectedPoste = allPostes[3];
      });
    } else {
      setState(() {
        allPostes = widget.postes;
        for(var poste in allPostes){
          if(employe?.poste_id == poste.id){
            selectedPoste = poste;
          }
        }
        //selectedPoste = allPostes[3];
      });
    }
  }

  Future<void> createEmploye() async {

    var request = http.MultipartRequest('POST', Uri.parse(r_employes));
    request.fields.addAll({
      'nom': ctrlNom.text,
      'adresse': ctrlAdresse.text,
      'telephone': ctrlTelephone.text,
      'email': ctrlEmail.text,
      'salaire': ctrlSalaire.text,
      'poste': selectedPoste!.id.toString()
    });

    request.headers.addAll(Globals.apiHeaders);

    startLoading();
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    endLoading();

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: responseData['messages']);
      if(context.mounted){
        Navigator.pop(context);
      }
    }
    else {
      if(responseData['messages'] == null){
        Fluttertoast.showToast(msg: responseData['message']);
      } else {
        Fluttertoast.showToast(msg: responseData['messages']);
      }
    }

  }

  Future<void> updateEmploye() async {

    var request = http.Request('PUT', Uri.parse("$r_employes/${widget.employe!.id!}"));
    request.body = json.encode({
      'nom': ctrlNom.text,
      'adresse': ctrlAdresse.text,
      'telephone': ctrlTelephone.text,
      'email': ctrlEmail.text,
      'salaire': ctrlSalaire.text,
      'poste': selectedPoste!.id.toString()
    });
    request.headers.addAll(Globals.apiHeaders);

    startLoading();
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    endLoading();

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: responseData['messages']);
      if(context.mounted){
        Navigator.pop(context);
      }
    }
    else {
      if(responseData['messages'] == null){
        Fluttertoast.showToast(msg: responseData['message']);
      } else {
        Fluttertoast.showToast(msg: responseData['messages']);
      }
    }

  }

  /*Future<void> getAllPostes() async {
    startLoading();
    final response = await http.get(Uri.parse(r_postes),
      headers: Globals.apiHeaders,
    );
    endLoading();

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      allPostes.clear();
      late Poste poste;
      for(int i = 0; i < responseBody['data']['postes'].length; i++){
        poste = Poste.fromJson(responseBody['data']['postes'][i]);
        allPostes.add(poste);
      }

      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}");
    }
  }*/

}
