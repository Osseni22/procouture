import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/components/message_box.dart';
import 'package:procouture/screens/confection/client/client_save_page.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/screens/confection/client/client_session.dart';
import 'package:http/http.dart'as http;

import '../../../utils/globals/global_var.dart';


class ClientPage extends StatefulWidget {
  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {

  bool searchBoolean = false;
  bool isLoading = false;

  List<Map<String, dynamic>> allClients = [];
  List<Map<String, dynamic>> foundClients = [];

  @override
  void initState() {
    getClientList();
    //foundClients = allClients;
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
        title: !searchBoolean ? textMontserrat('Liste des clients', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.w500) : searchTextField(),
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
          Expanded(
              child: Container(
                //padding: EdgeInsets.only(left: 13, right: 13, top: 10),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: foundClients.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 23, right: 23, top: 10),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                if(await msgBoxYesNo('Confirmation ', 'Supprimer ce client ?', context)){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  print('Le client ${index+1} Supprimé');
                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  print('Le client ${index+1} pas supprimé');
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
                            onTap: () {
                              Map<String, dynamic> selectedClient = {
                                "id": foundClients[index]['id'],
                                "ref": foundClients[index]['ref'],
                                "nom": foundClients[index]['nom'],
                                "adresse": foundClients[index]['adresse'],
                                "ville": foundClients[index]['ville'],
                                "telephone1": foundClients[index]['telephone1'],
                                "telephone2": foundClients[index]['telephone2'],
                                "email": foundClients[index]['email'],
                                "acompte": foundClients[index]['acompte'],
                                "atelier_id": foundClients[index]['atelier_id'],
                              };
                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SessionPage(map: selectedClient)));
                            },
                            child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: textLato(index != null ? '${foundClients[index]['nom'].toString().toUpperCase()}'.substring(0,1) : '', 18, Colors.black, TextAlign.center),
                                ),
                                title: textMontserrat('${foundClients[index]['nom']}', 16, Colors.black, TextAlign.left, fontWeight: FontWeight.w500),
                                subtitle: textWorkSans('${foundClients[index]['telephone1']}', 12, Colors.black, TextAlign.left),
                                trailing: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    child: IconButton(
                                      onPressed: () async {
                                        Map<String, dynamic> selectedClient = {
                                          "id": foundClients[index]['id'],
                                          "ref": foundClients[index]['ref'],
                                          "nom": foundClients[index]['nom'],
                                          "adresse": foundClients[index]['adresse'],
                                          "ville": foundClients[index]['ville'],
                                          "telephone1": foundClients[index]['telephone1'],
                                          "telephone2": foundClients[index]['telephone2'],
                                          "email": foundClients[index]['email'],
                                          "acompte": foundClients[index]['acompte'],
                                          "atelier_id": foundClients[index]['atelier_id'],
                                        };
                                        await Navigator.push(context, MaterialPageRoute(builder: (context) => ClientSave(pageMode: 'M', map: selectedClient,)));
                                        getClientList();
                                      },
                                      icon: Icon(Icons.edit_note_rounded),color: Colors.black,
                                    )
                                )
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
              child: textRaleway('${allClients.length} clients', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => ClientSave(pageMode: 'A', map: null,)));
          getClientList();
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
          hintText: 'Rechercher un client',
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

  Future<void> getClientList() async {
      String token = CnxInfo.token!;
      String bearerToken = 'Bearer $token';

      var myHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': bearerToken
      };

      startLoading();
      final response = await http.get(
        Uri.parse(r_client),
        headers: myHeaders,
      );
      endLoading();

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        //print(responseBody);
        allClients.clear();

        for(int i = 0; i < responseBody['data']['clients'].length; i++){
          Map<String, dynamic> dataMap = {
            "id": responseBody['data']['clients'][i]['id'],
            "ref": responseBody['data']['clients'][i]['ref'],
            "nom": responseBody['data']['clients'][i]['nom'],
            "adresse": responseBody['data']['clients'][i]['adresse'],
            "ville": responseBody['data']['clients'][i]['ville'],
            "telephone1": responseBody['data']['clients'][i]['telephone1'],
            "telephone2": responseBody['data']['clients'][i]['telephone2'],
            "email": responseBody['data']['clients'][i]['email'],
            "acompte": responseBody['data']['clients'][i]['acompte'],
            "atelier_id": responseBody['data']['clients'][i]['atelier_id'],
          };
          allClients.add(dataMap);
        }

        setState(() {foundClients = allClients;});

        // Handle the response
      } else {
        Fluttertoast.showToast(msg: "Status code: ${response.statusCode}");
        throw Exception('Failed to make Bearer auth request.');
      }
  }

  void runFilter(String enteredKeywords){
    List<Map<String, dynamic>> results = [];
    if(enteredKeywords.isEmpty){
      // If all the searchField is empty or only contains white-space, we get all the list
      results = allClients;
    } else {
      results = allClients.where((element) => element['nom'].toString().toLowerCase().contains(enteredKeywords.toLowerCase())).toList();
    }
    setState(() {
      foundClients = results;
    });

  }

}
