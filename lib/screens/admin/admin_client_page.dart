import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/models/Client.dart';
import 'package:procouture/screens/admin/admin_client_commande_page.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart'as http;

import '../../../utils/globals/global_var.dart';
import '../../models/Atelier.dart';


class AdminClientPage extends StatefulWidget {
  final Atelier atelier;
  const AdminClientPage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminClientPage> createState() => _AdminClientPageState();
}

class _AdminClientPageState extends State<AdminClientPage> {

  bool searchBoolean = false;
  bool isLoading = false;
  double clientInfoTextSize = 14;

  List<Client> allClients = [];
  List<Client> foundClients = [];
  Client? selectedClient;

  @override
  void initState() {
    getClientList();
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
        title: !searchBoolean ? textMontserrat('Clients', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.w500) : searchTextField(),
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
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: InkWell(
                          splashColor: Colors.orange.withOpacity(0.1),
                          onTap: (){
                            selectedClient = foundClients[index];
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (ctx) => showClientInfo(selectedClient!),
                              shape: const RoundedRectangleBorder( // <-- SEE HERE
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: textLato(foundClients[index].nom!.toUpperCase().substring(0,1), 18, Colors.black, TextAlign.center),
                              ),
                              title: textMontserrat('${foundClients[index].nom}', 18, Colors.black, TextAlign.left, fontWeight: FontWeight.w500),
                              subtitle: textWorkSans('${foundClients[index].telephone1}', 14, Colors.black, TextAlign.left),
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

    startLoading();
    final response = await http.get(Uri.parse(AdminRoutes.r_getClientsUrl(widget.atelier.id!)),
      headers: Globals.apiHeaders,
    );
    endLoading();
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {

      allClients.clear();
      late Client client;
      for(int i = 0; i < responseBody['data']['clients'].length; i++){
        client = Client.fromJson(responseBody['data']['clients'][i]);
        allClients.add(client);
      }
      allClients.sort((a, b) => a.nom!.compareTo(b.nom!));
      setState(() {foundClients = allClients;});
      // Handle the response
    } else {
      Fluttertoast.showToast(msg: "${responseBody['messages']}");
    }
  }

  void runFilter(String enteredKeywords){
    List<Client> results = [];
    if(enteredKeywords.isEmpty){
      // If all the searchField is empty or only contains white-space, we get all the list
      results = allClients;
    } else {
      results = allClients.where((element) => element.nom.toString().toLowerCase().contains(enteredKeywords.toLowerCase())).toList();
    }
    results.sort((a, b) => a.nom!.compareTo(b.nom!));
    setState(() {
      foundClients = results;
    });
  }

  Container showClientInfo(Client client){
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
          textMontserrat(client.nom!, 20, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
          SizedBox(height: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Ref
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textOpenSans('Référence: ', clientInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                    SizedBox(width: 5,),
                    textOpenSans(client.ref != null? client.ref! : '', clientInfoTextSize, Colors.black, TextAlign.start,),
                  ],
                ),
                // Telephone 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textOpenSans('Telephone 1: ', clientInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                    SizedBox(width: 5,),
                    textOpenSans(client.telephone1 != null? client.telephone1! : '', clientInfoTextSize, Colors.black, TextAlign.start,),
                  ],
                ),
                // Telephone 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textOpenSans('Telephone 2: ', clientInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                    SizedBox(width: 5,),
                    textOpenSans(client.telephone2 != null? client.telephone2! : '', clientInfoTextSize, Colors.black, TextAlign.start,),
                  ],
                ),
                // email
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textOpenSans('E-mail: ', clientInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                    SizedBox(width: 5,),
                    textOpenSans(client.email != null? client.email! : '', clientInfoTextSize, Colors.black, TextAlign.start,),
                  ],
                ),
                // ville
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textOpenSans('Ville: ', clientInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                    SizedBox(width: 5,),
                    textOpenSans(client.ville != null? client.ville! : '', clientInfoTextSize, Colors.black, TextAlign.start,),
                  ],
                ),
                // adresse
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    textOpenSans('Adresse: ', clientInfoTextSize, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
                    SizedBox(width: 5,),
                    textOpenSans(client.adresse != null? client.adresse! : '', clientInfoTextSize, Colors.black, TextAlign.start,),
                  ],
                ),
              ],
            )
          ),
          SizedBox(height: 7,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminClientCommandePage(atelier: widget.atelier, client: selectedClient!,)));
            },
            child: Container(
              height: 45,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: kProcouture_green
              ),
              child: textMontserrat("Commandes du client", 14, Colors.white, TextAlign.center, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }


}
