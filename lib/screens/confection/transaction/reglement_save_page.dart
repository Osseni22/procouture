import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart' as http;

import '../../../models/Commande.dart';
import '../../../models/ConfigData.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';
import '../../../widgets/default_app_bar.dart';

class ReglementSavePage extends StatefulWidget {
  final Commande commande;
  const ReglementSavePage({Key? key, required this.commande}) : super(key: key);

  @override
  State<ReglementSavePage> createState() => _ReglementSavePageState();
}

class _ReglementSavePageState extends State<ReglementSavePage> {

  bool isLoading = false;
  final format = DateFormat('dd/MM/yyyy');
  TextEditingController ctrlDate = TextEditingController();
  TextEditingController ctrlAmount = TextEditingController();
  bool showBanques = false;

  ModeReglement? selectedModeReg;

  @override
  void initState() {
    getAllModeReglements();
    ctrlDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar('Règlement de commande', context),
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
                    SizedBox(height: 10,),
                    // Info montant restant
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textMontserrat('Montant restant : ', 17, Colors.black, TextAlign.end),
                        SizedBox(width: 5,),
                        textMontserrat("${NumberFormat('#,###', 'fr_FR').format(widget.commande.montant_ttc! - widget.commande.montant_recu!)} ${CnxInfo.symboleMonnaie}", 17, kProcouture_green, TextAlign.start,fontWeight: FontWeight.w700),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 10,),
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
                        style: TextStyle(
                            fontFamily: 'OpenSans', fontWeight: FontWeight.w400),
                        textAlign: TextAlign.start,
                        format: format,
                        controller: ctrlDate,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '__/__/____',
                            hintStyle: TextStyle(
                                fontFamily: 'OpenSans', color: Colors.grey)
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
                      hint: textMontserrat('Choisir un pays',16,Colors.grey,TextAlign.left),
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
                          /*if(selectedModeReg != CmdeVar.allModeReglements[0]){
                            showBanques = true;
                          } else {
                            showBanques = false;
                          }*/
                        });
                      },
                    ),
                    SizedBox(height: 10,),
                    // Banque choice field
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: showBanques? 50 : 0,
                      child: DropdownButton<ModeReglement>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(8),
                        elevation: 8,
                        underline: SizedBox(),
                        hint: textMontserrat('Une banque',16,Colors.grey,TextAlign.left),
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
                          });
                        },
                      ),
                    ),
                    // Amount field
                    SizedBox(height: 10,),
                    Container(
                      ///padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                          //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 5),
                            onPressed: (){
                              ctrlAmount.text = "${widget.commande.montant_ttc! - widget.commande.montant_recu!}";
                            },
                              child: textMontserrat('Solder', 15, kProcouture_green, TextAlign.center,fontWeight: FontWeight.w500)
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: (){
                        createReglement();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: kProcouture_green
                        ),
                        child: textMontserrat('Régler la commande', 16, Colors.white, TextAlign.center),
                      ),
                    )
                  ]
              )
          )
      ) : const Center(child: CircularProgressIndicator()),
    );
  }

  // Create a règlement
  Future<void> createReglement() async {

    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
    };
    var request = http.MultipartRequest('POST', Uri.parse("$r_reglement/${widget.commande.id!}"));
    request.fields.addAll({
      'montant': ctrlAmount.text,
      'date': ctrlDate.text.replaceAll('/', '-'),
      'mode_reglement': selectedModeReg!.id.toString(),
      //'banque': '1'
    });
    if (selectedModeReg != CmdeVar.allModeReglements[0]) {
      request.fields.addAll(<String, String>{'banque' : '1'});
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

  // Get all the mode reglements
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

}
