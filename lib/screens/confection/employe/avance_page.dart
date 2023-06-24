import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:procouture/screens/confection/employe/avance_save_page.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/utils/constants/color_constants.dart';

import '../../../models/Avance.dart';
import '../../../utils/globals/global_var.dart';
import '../../../widgets/custom_text.dart';

class AvancePage extends StatefulWidget {
  const AvancePage({Key? key}) : super(key: key);

  @override
  State<AvancePage> createState() => _AvancePageState();
}

class _AvancePageState extends State<AvancePage> {

  bool searchBoolean = false;
  bool isLoading = false;
  double empInfoTextSize = 14;

  List<Avance> allAvances = [];
  List<Avance> foundAvances = [];

  @override
  void initState() {
    getAllAvances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: !searchBoolean ? textMontserrat('Avances', 17, Colors.black, TextAlign.center, fontWeight: FontWeight.w500) : searchTextField(),
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
                    itemCount: foundAvances.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 23, right: 23, top: 10),
                        child: Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              textMontserrat('${foundAvances[index].nom}', 16, Colors.black, TextAlign.start, fontWeight: FontWeight.w600),
                              foundAvances[index].montant != null ?
                              Row(
                                children: [
                                  textMontserrat('Montant : ', 14, Colors.black, TextAlign.start),
                                  textWorkSans("${NumberFormat('#,###', 'fr_FR').format(foundAvances[index].montant!)} ${CnxInfo.symboleMonnaie}", 16, kProcouture_green, TextAlign.left,fontWeight: FontWeight.w600),
                                ],
                              ) : SizedBox(),
                              Row(
                                children: [
                                  textMontserrat('Date : ', 14, Colors.black, TextAlign.start),
                                  textWorkSans("${Globals.convertDateEnToFr(foundAvances[index].date!)}", 14, Colors.blueGrey, TextAlign.left,fontWeight: FontWeight.w500),
                                ],
                              ),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      ),
                    )
                ),
              ),
          SizedBox(height: 30,),
          Container(
              alignment: Alignment.centerRight,
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: textRaleway('${allAvances.length} avances enregistrées', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        backgroundColor: kProcouture_green,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AvanceSavePage()));
          getAllAvances();
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

  Future<void> getAllAvances() async {
    startLoading();
    final response = await http.get(Uri.parse(r_avances),
      headers: Globals.apiHeaders,
    );
    endLoading();
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {

      allAvances.clear();
      late Avance avance;
      for(int i = 0; i < responseBody['data']['avances'].length; i++){
        avance = Avance.fromJson(responseBody['data']['avances'][i]);
        allAvances.add(avance);
      }
      allAvances.sort((a, b) => b.id!.compareTo(a.id!));
      setState(() {foundAvances = allAvances;});
      // Handle the response
    } else {
      if (responseBody['messages'] != null) {
        Fluttertoast.showToast(msg: "${responseBody['messages']}");
      } else {
        Fluttertoast.showToast(msg: "${responseBody['message']}");
      }
    }
  }

  void runFilter(String enteredKeywords){
    List<Avance> results = [];
    if(enteredKeywords.isEmpty){
      // If all the searchField is empty or only contains white-space, we get all the list
      results = allAvances;
    } else {
      results = allAvances.where((element) => element.nom.toString().toLowerCase().contains(enteredKeywords.toLowerCase())).toList();
    }
    results.sort((a, b) => a.nom!.compareTo(b.nom!));
    setState(() {
      foundAvances = results;
    });
  }

}
