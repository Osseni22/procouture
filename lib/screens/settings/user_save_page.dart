import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:http/http.dart' as http;

import '../../models/User.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/globals/global_var.dart';

class UserSave extends StatefulWidget {
  final String pageMode; final int atelier_id;
  UserSave({Key? key, required this.pageMode, required this.atelier_id}) : super(key: key);

  @override
  State<UserSave> createState() => _UserSaveState();
}

class _UserSaveState extends State<UserSave> {

  bool isSaving = false;

  TextEditingController nomCtrl = TextEditingController(text: '');
  TextEditingController prenomCtrl = TextEditingController(text: '');
  TextEditingController userNameCtrl = TextEditingController(text: '');
  TextEditingController emailCtrl = TextEditingController(text: '');
  TextEditingController motDePasseCtrl = TextEditingController(text: '');
  TextEditingController motDePasseCtrl2 = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Fiche Utilisateur', context, textSize: 18),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 400,
                  padding:  EdgeInsets.all(5),
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
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          controller: nomCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nom',
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
                          controller: prenomCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Prénom(s)',
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
                          controller: userNameCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nom utilisateur',
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
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
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
                          controller: motDePasseCtrl,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mot de passe',
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
                          controller: motDePasseCtrl2,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirmer mot de passe',
                              hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                GestureDetector(
                  onTap: (){
                    if(allOK()){
                      if(widget.pageMode == 'A'){
                        User user = User(
                            id: 0,
                            nom: nomCtrl.text,
                            prenom: prenomCtrl.text,
                            email: emailCtrl.text,
                            username: userNameCtrl.text,
                            atelier_id: widget.atelier_id,
                            password: motDePasseCtrl.text
                        );
                        createUser(user);
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: double.infinity,
                    padding:  EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: kProcouture_green,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 10)
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textMontserrat('Valider', 18, Colors.white, TextAlign.center),
                        isSaving? const SizedBox(width: 10,) : const SizedBox(),
                        isSaving? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                        ): const SizedBox()
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

  void savingIndicator(bool showIndicator){
    if(showIndicator){
      setState(() {
        isSaving = true;
      });
    } else {
      setState(() {
        isSaving = false;
      });
    }
  }

  bool allOK(){
    if(nomCtrl.text.isEmpty){
      Fluttertoast.showToast(msg: "Nom obligatoire");
      return false;
    }
    if(userNameCtrl.text.isEmpty){
      Fluttertoast.showToast(msg: "Nom de l'utilisateur obligatoire");
      return false;
    }
    if(motDePasseCtrl.text.length < 6){
      Fluttertoast.showToast(msg: "Mot de passe : 6 caractères au minimum");
      return false;
    }
    if(motDePasseCtrl.text != motDePasseCtrl2.text){
      Fluttertoast.showToast(msg: "Mots de passe non identiques");
      return false;
    }
    return true;
  }

  Future<void> createUser(User user) async {

    Map<String, dynamic> data = user.toJson();
    String bearerToken = 'Bearer ${CnxInfo.token!}';

    savingIndicator(true);
    final response = await http.post(
        Uri.parse('$r_ateliers/${widget.atelier_id}/users'),
        body: json.encode(data),
        headers: {
          'Accept':'application/json',
          'Content-Type':'application/json',
          'Authorization': bearerToken,
        }
    );
    savingIndicator(false);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: 'Utilisateur enregistré avec succès !');
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: '${response.statusCode} Utilisateur pas enregistré !');
      final responseBody = jsonDecode(response.body);
      print(responseBody);
    }
  }

}
