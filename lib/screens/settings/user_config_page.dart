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
import 'package:procouture/screens/settings/user_save_page.dart';
import 'package:procouture/services/api_routes/routes.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/screens/confection/client/client_session.dart';
import 'package:http/http.dart'as http;

import '../../../utils/globals/global_var.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {

  bool searchBoolean = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: textLato('Liste des utilisateurs', 20, Colors.black, TextAlign.center),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          Expanded(
              child: Container(

                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.only(left: 23, right: 23, top: 10),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                if(await msgBoxYesNo('Confirmation ', 'Supprimer cet utilisateur ?', context)){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await Future.delayed(Duration(seconds: 2));
                                  print("L'utilisateur ${index+1} Supprimé");
                                  setState(() {
                                    isLoading = false;
                                  });
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
                                  child: textLato('Utilisateurs $index'.substring(0,1), 22, Colors.black, TextAlign.center),
                                ),
                                const SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      textLato('Utilisateur ${index+1}', 19, Colors.black, TextAlign.left),
                                      const SizedBox(height: 2,),
                                      textWorkSans('00 11 22 33 44 55', 14, Colors.grey, TextAlign.left),
                                      const SizedBox(height: 2,),
                                      textWorkSans('utilisateur${index+1}@mail.com', 14, Colors.grey, TextAlign.left)
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
              )
          ),
          Container(
              alignment: Alignment.centerRight,
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: textRaleway('10 utilisateurs enregistrés', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7.0,
        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => UserSave()));},
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
          fontFamily: 'Lato'
      ),
      textInputAction: TextInputAction.search, //Specify the action button on the keyboard
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Rechercher un utilisateur',
          hintStyle: TextStyle(fontFamily: 'Lato', color: Colors.grey, fontSize: 20)
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

}
