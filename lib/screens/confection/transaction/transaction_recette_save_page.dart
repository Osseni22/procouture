import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart' as http;

import '../../../models/Banque.dart';
import '../../../models/Commande.dart';
import '../../../models/ConfigData.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';
import '../../../widgets/default_app_bar.dart';

class NouvelleRecetteSavePage extends StatefulWidget {
  /*final int typeTransaction;*/ // 1 Pour recette, 2 pour dépense
  final int base; // 1 for Confection, 2 for Boutique, 3 for Banque
  const NouvelleRecetteSavePage({Key? key,/* required this.typeTransaction*/ required this.base}) : super(key: key);

  @override
  State<NouvelleRecetteSavePage> createState() => _NouvelleRecetteSavePageState();
}

class _NouvelleRecetteSavePageState extends State<NouvelleRecetteSavePage> {

  bool isLoading = false;
  final format = DateFormat('dd/MM/yyyy');
  TextEditingController ctrlDate = TextEditingController();
  TextEditingController ctrlAmount = TextEditingController();
  TextEditingController ctrlLibelle = TextEditingController();
  bool showBanques = false;

  ModeReglement? selectedModeReg;

  List<Banque> allBanques = [];
  Banque? selectedBanque;

  @override
  void initState() {
    getAllModeReglements();
    getAllBanques();
    ctrlDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar(getPageTitle(), context),
      body: !isLoading? Center(
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: showBanques? 380 : 330,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 10)
                    )
                  ]
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ctrlLibelle,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Libellé',
                                  hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    // Date field
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        //border: Border.all(color: Colors.grey.withOpacity(0.5))
                      ),
                      child: DateTimeField(
                        resetIcon: null,
                        style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                        textAlign: TextAlign.start,
                        format: format,
                        controller: ctrlDate,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '__/__/____',
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
                    SizedBox(height: 10,),
                    // Mode règlement field
                    DropdownButton<ModeReglement>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(8),
                      elevation: 8,
                      underline: SizedBox(),
                      hint: textMontserrat('Choisir un mode de règlement',16,Colors.grey,TextAlign.left),
                      value: selectedModeReg,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      items: CmdeVar.allModeReglements.map((ModeReglement modereglement) {
                        return DropdownMenuItem<ModeReglement>(
                          value: modereglement,
                          child: textMontserrat(modereglement.libelle!,16,Colors.black, TextAlign.left),
                        );
                      }).toList(),
                      onChanged: (ModeReglement? value) {
                        setState(() {
                          selectedModeReg = value!;
                          if(selectedModeReg != CmdeVar.allModeReglements[0]){
                            showBanques = true;
                          } else {
                            showBanques = false;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10,),
                    // Banque choice field
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: showBanques? 50 : 0,
                      child: DropdownButton<Banque>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(8),
                        elevation: 8,
                        underline: SizedBox(),
                        hint: textMontserrat('Une banque',16,Colors.grey,TextAlign.left),
                        value: selectedBanque,
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        items: allBanques.map((Banque banque) {
                          return DropdownMenuItem<Banque>(
                            value: banque,
                            child: textMontserrat(banque.libelle!,16,Colors.black, TextAlign.left),
                          );
                        }).toList(),
                        onChanged: (Banque? value) {
                          setState(() {
                            selectedBanque = value!;
                          });
                        },
                      ),
                    ),
                    // Amount field
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ctrlAmount,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Montant',
                                hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: (){
                        createNouvelleRecette();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: kProcouture_green
                        ),
                        child: textMontserrat('Valider', 16, Colors.white, TextAlign.center),
                      ),
                    )
                  ]
              )
          )
      ) : const Center(child: CircularProgressIndicator()),
    );
  }

  // Create a 'recette'
  Future<void> createNouvelleRecette() async {

    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
    };
    var request = http.MultipartRequest('POST', Uri.parse(r_tresorerieNewRecette));
    request.fields.addAll({
      'libelle': ctrlLibelle.text,
      'montant': ctrlAmount.text,
      'date': ctrlDate.text.replaceAll('/', '-'),
      'mode_reglement': selectedModeReg!.id.toString(),
      'base': widget.base.toString(),
    });
    if (selectedModeReg != CmdeVar.allModeReglements[0]) {
      request.fields.addAll(<String, String>{'banque' : selectedBanque!.id.toString()});
    }

    request.headers.addAll(headers);

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    loadingProgress(false);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(responseString);
      Fluttertoast.showToast(msg: responseData['messages']);
      Navigator.pop(context);
    }
    else {
      final responseData = jsonDecode(responseString);
      Fluttertoast.showToast(msg: responseData['messages']);
    }

  }

  // Get all the mode règlements
  Future<void> getAllModeReglements() async {
    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };
    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_commandeInfos),
      headers: myHeaders,
    );
    loadingProgress(false);

    if (response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      late ModeReglement modeReglement;
      /// GET MODE REGLEMENT LIST
      CmdeVar.allModeReglements.clear();
      for(int i = 0; i < responseBody['data']['mode_reglements'].length; i++){
        modeReglement = ModeReglement.fromJson(responseBody['data']['mode_reglements'][i]);
        CmdeVar.allModeReglements.add(modeReglement);
      }
      selectedModeReg = CmdeVar.allModeReglements[0];

    } else {
      final responseBody = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${responseBody['message']}");
    }

  }
  // Get all the mode reglements
  Future<void> getAllBanques() async {

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_banquesUser),
      headers: Globals.apiHeaders,
    );
    loadingProgress(false);

    if (response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      late Banque banque;
      /// GET ALL BANKS
      allBanques.clear();
      for(int i = 0; i < responseBody['data']['banques'].length; i++){
        banque = Banque.fromJson(responseBody['data']['banques'][i]);
        allBanques.add(banque);
      }
      selectedBanque = allBanques[0];

    } else {
      final responseBody = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${responseBody['message']}");
    }

  }

  void loadingProgress(bool value) {
    if(value){
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getPageTitle(){
    if(widget.base == 1){
      return 'Nouvelle recette confection';
    }
    if(widget.base == 2){
      return 'Nouvelle recette boutique';
    }
    if(widget.base == 3){
      return 'Nouvelle recette banque';
    }
    return 'Nouvelle recette confection';
  }

}
