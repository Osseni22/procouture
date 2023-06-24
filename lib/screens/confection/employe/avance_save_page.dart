import 'dart:convert';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../models/Banque.dart';
import '../../../models/CategorieDepense.dart';
import '../../../models/ConfigData.dart';
import '../../../models/Employe.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/constants/color_constants.dart';
import '../../../utils/globals/global_var.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/default_app_bar.dart';

class AvanceSavePage extends StatefulWidget {
  const AvanceSavePage({Key? key}) : super(key: key);

  @override
  State<AvanceSavePage> createState() => _AvanceSavePageState();
}

class _AvanceSavePageState extends State<AvanceSavePage> {

  bool isLoading = false;
  bool isSubmitting = false;
  final format = DateFormat('dd/MM/yyyy');
  TextEditingController ctrlDate = TextEditingController();
  TextEditingController ctrlAmount = TextEditingController();
  bool showBanques = false;

  ModeReglement? selectedModeReg;

  List<Banque> allBanques = [];
  Banque? selectedBanque;

  List<CategorieDepense> allCategorieDepenses = [];
  CategorieDepense? selectedCategorieDepense;

  List<Employe> allEmployes = [];
  List<Employe> foundEmployes = [];
  Employe? selectedEmploye;

  @override
  void initState() {
    loadAll();
    ctrlDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar('Fiche Avance', context),
      body: !isLoading? Center(
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: showBanques? 445 : 395,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
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
                    // Employe field
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<Employe>(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(8),
                            elevation: 8,
                            underline: SizedBox(),
                            hint: textMontserrat('Choisir un employé',16,Colors.grey,TextAlign.left),
                            value: selectedEmploye,
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            items: allEmployes.map((Employe employe) {
                              return DropdownMenuItem<Employe>(
                                value: employe,
                                child: textMontserrat(employe.nom!,16,Colors.black, TextAlign.left),
                              );
                            }).toList(),
                            onChanged: (Employe? value) {
                              setState(() {
                                selectedEmploye = value!;
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                            onTap: (){
                              setState(() {
                                foundEmployes = allEmployes;
                              });
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (ctx) => selectEmploye(),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(14.0),
                                  ),
                                ),
                              );
                            },
                          child: Icon(Icons.more_horiz_outlined)
                        )
                      ],
                    ),SizedBox(height: 10,),
                    // Mode categorie depense field
                    DropdownButton<CategorieDepense>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(8),
                      elevation: 8,
                      underline: SizedBox(),
                      hint: textMontserrat('Choisir une catégorie dépense',16,Colors.grey,TextAlign.left),
                      value: selectedCategorieDepense,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      items: allCategorieDepenses.map((CategorieDepense categorieDepense) {
                        return DropdownMenuItem<CategorieDepense>(
                          value: categorieDepense,
                          child: textMontserrat(categorieDepense.libelle!,16,Colors.black, TextAlign.left),
                        );
                      }).toList(),
                      onChanged: (CategorieDepense? value) {
                        setState(() {
                          selectedCategorieDepense = value!;
                          /*if(selectedModeReg != CmdeVar.allModeReglements[0]){
                            showBanques = true;
                          } else {
                            showBanques = false;
                          }*/
                        });
                      },
                    ),
                    SizedBox(height: 10,),
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
                        if(verifBeforeSubmitting()){
                          createAvance();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: kProcouture_green
                        ),
                       child:  !isSubmitting? textMontserrat('Valider', 16, Colors.white, TextAlign.center) : CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                      ),
                    )
                  ]
              )
          )
      ) : const Center(child: CircularProgressIndicator()),
    );
  }

  Container selectEmploye() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StatefulBuilder(
        builder: (context, state) =>
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  // Afficher le champ de recherche et le bouton de fermeture
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10,),
                                Icon(Icons.search, color: Colors.black,),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: TextField(
                                    //controller: designationCtrl,
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Rechercher un employé',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey),
                                    ),
                                    onChanged: (value) {
                                      runEmployeFilter(value);
                                      setState(() {});
                                      state(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Champ de recherche
                  SizedBox(height: 5,),
                  // Afficher ici la liste des clients
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: foundEmployes.length,
                          itemBuilder: (context, int index) =>
                              InkWell(
                                onTap: () {
                                  selectedEmploye =
                                  foundEmployes[index];
                                  /*scaffoldKey.currentState?.*/
                                  setState(() {
                                  });
                                  //print(CmdeVar.selectedClient?.nom);
                                  Navigator.pop(context);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    child: textLato(
                                        foundEmployes[index].nom
                                            .toString().toUpperCase().substring(
                                            0, 1), 18, Colors.black,
                                        TextAlign.center),
                                  ),
                                  title: textMontserrat(
                                      '${foundEmployes[index].nom}', 16,
                                      Colors.black, TextAlign.left,
                                      fontWeight: FontWeight.w400),
                                  //subtitle: textWorkSans('${CmdeVar.foundClients[index].telephone1}', 12, Colors.black, TextAlign.left),
                                ),
                              )
                      ),
                    ),
                  ),
                  SizedBox(height: 2,),
                ],
              ),
            ),
      ),
    );
  }

  void runEmployeFilter(String enteredKeywords) {
    List<Employe> results = [];
    if (enteredKeywords.isEmpty) {
      results = allEmployes;
    } else {
      results = allEmployes.where((element) =>
          element.nom.toString().toLowerCase().contains(
              enteredKeywords.toLowerCase())).toList();
    }
    setState(() {
       foundEmployes = results;
    });
  }


  void loadingProgress(bool value) {
    if(value){
      setState(() {
        isLoading = true;
        isSubmitting = true;
      });
    } else {
      setState(() {
        isLoading = false;
        isSubmitting = false;
      });
    }
  }
  void submitting(bool value) {
    if(value){
      setState(() {
        isSubmitting = true;
      });
    } else {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void loadAll(){
    getAllBanques();
    getAllCategorieDepense();
    getAllModeReglements();
    getAllEmployes();
  }

  // Get all the 'Categorie Dépense'
  Future<void> getAllCategorieDepense() async {

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_categorieDepense),
      headers: Globals.apiHeaders,
    );
    loadingProgress(false);

    if (response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      late CategorieDepense categorieDepense;

      /// GET ALL CATEGORIES
      allCategorieDepenses.clear();
      for(int i = 0; i < responseBody['data']['categorie_depenses'].length; i++){
        categorieDepense = CategorieDepense.fromJson(responseBody['data']['categorie_depenses'][i]);
        allCategorieDepenses.add(categorieDepense);
      }
      //selectedCategorieDepense = allCategorieDepenses[0];

    } else {
      final responseBody = jsonDecode(response.body);
      if(responseBody['messages'] != null){
        Fluttertoast.showToast(msg: "${responseBody['messages']}");
      } else {
        if (responseBody['messages'] != null) {
          Fluttertoast.showToast(msg: "${responseBody['messages']}");
        } else {
          Fluttertoast.showToast(msg: "${responseBody['message']}");
        }
      }
    }
  }

  // Get all the 'Banques'
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
      if(responseBody['messages'] != null){
        Fluttertoast.showToast(msg: "${responseBody['messages']}");
      } else {
        if (responseBody['messages'] != null) {
          Fluttertoast.showToast(msg: "${responseBody['messages']}");
        } else {
          Fluttertoast.showToast(msg: "${responseBody['message']}");
        }
      }
    }
  }

  // Get all the 'Mode Règlements'
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
      //selectedModeReg = CmdeVar.allModeReglements[0];

    } else {
      final responseBody = jsonDecode(response.body);
      if(responseBody['messages'] != null){
        Fluttertoast.showToast(msg: "${responseBody['messages']}");
      } else {
        if (responseBody['messages'] != null) {
          Fluttertoast.showToast(msg: "${responseBody['messages']}");
        } else {
          Fluttertoast.showToast(msg: "${responseBody['message']}");
        }
      }
    }

  }

  // get all the employes
  Future<void> getAllEmployes() async {
    loadingProgress(true);
    final response = await http.get(Uri.parse(r_employes),
      headers: Globals.apiHeaders,
    );
    loadingProgress(false);
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {

      allEmployes.clear();
      late Employe employe;
      for(int i = 0; i < responseBody['data']['employes'].length; i++){
        employe = Employe.fromJson(responseBody['data']['employes'][i]);
        allEmployes.add(employe);
      }
      allEmployes.sort((a, b) => a.nom!.compareTo(b.nom!));
      foundEmployes = allEmployes;
      setState(() {selectedEmploye = foundEmployes[0];});

      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}");
    }
  }

  bool verifBeforeSubmitting(){
    if(selectedModeReg != null && selectedCategorieDepense != null){
      return true;
    }
    Fluttertoast.showToast(msg: 'Renseigner tous les champs');
    return false;
  }

  // Create an avance
  Future<void> createAvance() async {

    var request = http.MultipartRequest('POST', Uri.parse(r_avances));
    request.fields.addAll({
      'date': ctrlDate.text.replaceAll('/', '-'),
      'montant': ctrlAmount.text,
      'mode_reglement': selectedModeReg!.id.toString(),
      'categorie_depense': selectedCategorieDepense!.id.toString(),
      'employe': selectedEmploye!.id.toString(),
      //'banque': '12'
    });

    if (selectedModeReg != CmdeVar.allModeReglements[0]) {
      request.fields.addAll(<String, String>{'banque' : selectedBanque!.id.toString()});
    }

    request.headers.addAll(Globals.apiHeaders);

    submitting(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    submitting(false);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: responseData['messages']);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
    else {
      if(responseData['messages'] != null){
        Fluttertoast.showToast(msg: responseData['messages']);
      } else {
        Fluttertoast.showToast(msg: responseData['message']);
      }
    }

  }

}
