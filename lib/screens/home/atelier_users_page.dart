import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:procouture/screens/settings/user_save_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart' as http;

import '../../components/message_box.dart';
import '../../models/Atelier.dart';
import '../../models/User.dart';
import '../../services/api_routes/routes.dart';
import '../../widgets/default_app_bar.dart';

class AtelierUsersPage extends StatefulWidget {
  Atelier? atelier;
  AtelierUsersPage({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AtelierUsersPage> createState() => _AtelierUsersPageState();
}

class _AtelierUsersPageState extends State<AtelierUsersPage> {

  bool isLoading = false;
  bool isExpanded = false;

  List<User> allAtelierUsers = [];

  @override
  void initState() {
    getAllAtelierUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: myDefaultAppBar(widget.atelier!.libelle!,context),
      body: isLoading ? LinearProgressIndicator(backgroundColor: Colors.transparent,)
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
              child: Column(
                children: [
                  AnimatedContainer(
                    padding: EdgeInsets.only(left:10, top: 5, bottom: 5 ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kProcouture_green
                    ),
                    duration: Duration(milliseconds: 500),
                    height: isExpanded ? 150 : 60,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                  child: Row(
                                    children: [
                                      textMontserrat("Solde : ", 19, Colors.white, TextAlign.start),
                                      SizedBox(width: 5,),
                                      textOpenSans("${widget.atelier!.solde.toString()} ${widget.atelier!.monnaie!.symbole!}", 22, Colors.white, TextAlign.start, fontWeight: FontWeight.w700)
                                    ],
                                  )
                              ),
                            ),
                            IconButton(onPressed: (){
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            }, icon: !isExpanded? Icon(Icons.keyboard_double_arrow_down_sharp, color: Colors.white,): Icon(Icons.keyboard_double_arrow_up_sharp, color: Colors.white,))
                          ],
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text("Informations a afficher ici", style: TextStyle(color: Colors.white),),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  textMontserrat('Liste des utilisateurs', 14, Colors.grey, TextAlign.center),
                  //SizedBox(height: 10,),
                  Expanded(
                      child: allAtelierUsers.isNotEmpty ?
                      Container(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                            itemCount: allAtelierUsers.length,
                            itemBuilder: (BuildContext context, int index) => Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        if(await msgBoxYesNo('Confirmation ', 'Supprimer cet utilisateur ?', context)){
                                          // delete code
                                        } else {
                                          print("L'utilisateur ${index+1} pas supprimé");
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
                                  height: 85,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 23,
                                          backgroundColor: Colors.orange,
                                          child: textLato(allAtelierUsers[index].nom!.substring(0,1).toUpperCase(), 22, Colors.black, TextAlign.center),
                                        ),
                                        const SizedBox(width: 20,),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              textLato(allAtelierUsers[index].nom!, 21, Colors.black, TextAlign.left),
                                              const SizedBox(height: 2,),
                                              textWorkSans(allAtelierUsers[index].username != null? allAtelierUsers[index].username! : '', 14, Colors.grey, TextAlign.left),
                                              const SizedBox(height: 2,),
                                              textWorkSans(allAtelierUsers[index].email != null ? allAtelierUsers[index].email!: '', 14, Colors.grey, TextAlign.left)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ) : Center(child: Text('Aucun Utilisateur enregistré'),)
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context)=> UserSave(pageMode: 'A',atelier_id: widget.atelier!.id!,)));
          getAllAtelierUsers();
        },
        backgroundColor: kProcouture_green,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Future<void> getAllAtelierUsers() async {
    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

    loadingProgress(true);
    final response = await http.get(
      Uri.parse('$r_ateliers/${widget.atelier!.id!}/users'),
      headers: myHeaders,
    );
    loadingProgress(false);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      late User user;

      for (int i = 0; i < responseBody['data']['users'].length; i++) { // Get all users
        print('///////////');
        print(responseBody['data']['users'][i]);
        user = User.fromJson(responseBody['data']['users'][i]);
        allAtelierUsers.add(user);
      }
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

}
