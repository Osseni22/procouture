import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/models/Employe.dart';
import 'package:procouture/models/Poste.dart';
import 'package:procouture/screens/confection/employe/employe_save_page.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart'as http;

import '../../../components/message_box.dart';
import '../../../utils/globals/global_var.dart';


class EmployePage extends StatefulWidget {
  const EmployePage({Key? key,}) : super(key: key);

  @override
  State<EmployePage> createState() => _EmployePageState();
}

class _EmployePageState extends State<EmployePage> {

  bool searchBoolean = false;
  bool isLoading = false;
  double empInfoTextSize = 14;

  List<Employe> allEmployes = [];
  List<Employe> foundEmployes = [];
  Employe? selectedEmploye;
  List<Poste> allPostes = [];


  @override
  void initState() {
    loadAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: !searchBoolean ? textMontserrat('Employés', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.w500) : searchTextField(),
        centerTitle: true,
        actions: [
          !searchBoolean ?
          IconButton(onPressed: (){
            setState(() {
              searchBoolean = true;
            });
          },
            icon: const Icon(Icons.search), color: Colors.black,
          ) :
          IconButton(onPressed: (){
            setState(() {
              searchBoolean = false;
              runFilter('');
            });
          },
            icon: Icon(Icons.close), color: Colors.black,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          SizedBox(height: 10,),
          Expanded(
              child: Container(
                //padding: EdgeInsets.only(left: 13, right: 13, top: 10),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: foundEmployes.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 23, right: 23, top: 10),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                if(await msgBoxYesNo('Confirmation ', 'Supprimer cet employé ?', context)){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  print('Le employé ${index+1} Supprimé');
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  print('Le employé ${index+1} pas supprimé');
                                };
                              },
                              icon: CupertinoIcons.delete,
                              label: 'Supprimer',
                              backgroundColor: Colors.red.shade300,
                              borderRadius: BorderRadius.circular(15),
                            )
                          ],
                        ),
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: InkWell(
                            splashColor: Colors.orange.withOpacity(0.1),
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeSave(postes: allPostes, pageMode: 'M', employe: foundEmployes[index],)));
                              loadAll();
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: textLato(foundEmployes[index].nom!.toUpperCase().substring(0,1), 18, Colors.black, TextAlign.center),
                              ),
                              title: textMontserrat('${foundEmployes[index].nom}', 15, Colors.black, TextAlign.left, fontWeight: FontWeight.w500),
                              subtitle: foundEmployes[index].salaire != null ?
                              textWorkSans("${foundEmployes[index].telephone} (Salaire: ${NumberFormat('#,###', 'fr_FR').format(foundEmployes[index].salaire!)} ${CnxInfo.symboleMonnaie})", 12, Colors.blueGrey, TextAlign.left,fontWeight: FontWeight.w600)
                                  : SizedBox(),
                              trailing: CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  child: IconButton(
                                    onPressed: () {
                                      selectedEmploye = foundEmployes[index];
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (ctx) => showEmployeInfo(selectedEmploye!),
                                        shape: const RoundedRectangleBorder( // <-- SEE HERE
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20.0),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(CupertinoIcons.doc_person),color: Colors.black,
                                  )
                              )
                              ,
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              )
          ),
          Container(
              alignment: Alignment.centerRight,
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: textRaleway('${allEmployes.length} employés', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeSave(pageMode: 'A', postes: allPostes,)));
          loadAll();
        },
        isExtended: true,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget searchTextField() {
    return TextField(
      autofocus: true, //Display the keyboard when TextField is displayed
      cursorColor: Colors.green,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'OpenSans'
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Rechercher un employé',
          hintStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.grey, fontSize: 20)
      ),
      onChanged: (value) => runFilter(value),
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

  void loadAll(){
    getAllEmployes();
    getAllPostes();
  }

  String? getPoste(Employe employe){
    for(var poste in allPostes){
      if(employe.poste_id == poste.id){
        return poste.libelle!;
      }
    }
    return null;
  }

  Future<void> getAllEmployes() async {
    startLoading();
    final response = await http.get(Uri.parse(r_employes),
      headers: Globals.apiHeaders,
    );
    endLoading();
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {

      allEmployes.clear();
      late Employe employe;
      for(int i = 0; i < responseBody['data']['employes'].length; i++){
        employe = Employe.fromJson(responseBody['data']['employes'][i]);
        allEmployes.add(employe);
      }
      allEmployes.sort((a, b) => a.nom!.compareTo(b.nom!));
      setState(() {foundEmployes = allEmployes;});
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}");
    }
  }

  Future<void> getAllPostes() async {
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
  }

  void runFilter(String enteredKeywords){
    List<Employe> results = [];
    if(enteredKeywords.isEmpty){
      // If all the searchField is empty or only contains white-space, we get all the list
      results = allEmployes;
    } else {
      results = allEmployes.where((element) => element.nom.toString().toLowerCase().contains(enteredKeywords.toLowerCase())).toList();
    }
    results.sort((a, b) => a.nom!.compareTo(b.nom!));
    setState(() {
      foundEmployes = results;
    });
  }

  Container showEmployeInfo(Employe employe){
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.black,),
          ),
          SizedBox(height: 5,),
          textMontserrat(employe.nom!, 20, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
          SizedBox(height: 10,),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reference
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Reference: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.ref != null? employe.ref! : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // Telephone 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Telephone: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.telephone != null? employe.telephone! : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('E-mail: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.email != null? employe.email! : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // ville
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Ville: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.ville != null? employe.ville! : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // adresse
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Adresse: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.adresse != null? employe.adresse! : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Salaire: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.salaire != null? "${NumberFormat('#,###', 'fr_FR').format(employe.salaire!)} ${CnxInfo.symboleMonnaie}" : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Avance: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.avance_salaire != null? "${NumberFormat('#,###', 'fr_FR').format(employe.avance_salaire!)} ${CnxInfo.symboleMonnaie}" : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Commission: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.comission != null? "${NumberFormat('#,###', 'fr_FR').format(employe.comission!)} ${CnxInfo.symboleMonnaie}" : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),
                  // Poste
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textOpenSans('Poste: ', empInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                      SizedBox(width: 5,),
                      textOpenSans(employe.poste_id != null? getPoste(employe)! : '', empInfoTextSize, Colors.black, TextAlign.start,),
                    ],
                  ),

                ],
              )
          ),
          SizedBox(height: 7,),
        ],
      ),
    );
  }

}
