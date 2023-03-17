import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/screens/home/atelier_page.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/custom_field_container.dart';

import '../../utils/constants/color_constants.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final _key = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureText2 = true;
  double textFieldHeight = 60;

  TextEditingController ctrlPrenom = TextEditingController();
  TextEditingController ctrlNom = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlTelephone = TextEditingController();
  TextEditingController ctrlAdresse = TextEditingController();
  TextEditingController ctrlMotDePasse = TextEditingController();
  TextEditingController ctrlConfirmMotDePasse = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    ctrlPrenom.dispose();
    ctrlNom.dispose();
    ctrlEmail.dispose();
    ctrlTelephone.dispose();
    ctrlAdresse.dispose();
    ctrlMotDePasse.dispose();
    ctrlConfirmMotDePasse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Inscription', context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/appstore.png')
                    )
                  ),
                ),
                SizedBox(height: 30,),

                // Champ Atelier
                CustomFieldContainer(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller: ctrlPrenom,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_outline),
                      hintText: 'Prénom(s)',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none, // Enlever la bordure du bas
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kProcouture_green, width: 1),
                      ),
                    ),
                    validator: (vNomAtelier) {
                      if(vNomAtelier!.isEmpty) {
                        return "Le(s) prénom(s) est requis";
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomFieldContainer(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller: ctrlNom,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Nom',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none, // Enlever la bordure du bas
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kProcouture_green, width: 1),
                      ),
                    ),
                    validator: (vNomAtelier) {
                      if(vNomAtelier!.isEmpty) {
                        return "Le nom est requis";
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomFieldContainer(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller: ctrlEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail_rounded),
                      hintText: 'Email',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none, // Enlever la bordure du bas
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kProcouture_green, width: 1),
                      ),
                    ),
                    validator: (vNomAtelier) {
                      if(vNomAtelier!.isEmpty) {
                        return "L'Email est requis";
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomFieldContainer(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller: ctrlTelephone,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: 'Telephone',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none, // Enlever la bordure du bas
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kProcouture_green, width: 1),
                      ),
                    ),
                    validator: (vNomAtelier) {
                      if(vNomAtelier!.isEmpty) {
                        return "Le Telephone est requis";
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomFieldContainer(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller: ctrlAdresse,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(CupertinoIcons.location_solid),
                      hintText: 'Adresse',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none, // Enlever la bordure du bas
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kProcouture_green, width: 1),
                      ),
                    ),
                    validator: (vNomAtelier) {
                      if(vNomAtelier!.isEmpty) {
                        return "L'adresse est requise";
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomFieldContainer(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller: ctrlMotDePasse,
                    obscureText: obscureText,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(obscureText? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill),
                        onPressed: (){
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                      icon: const Icon(CupertinoIcons.lock_circle),
                      hintText: 'Mot de passe',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none, // Enlever la bordure du bas
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kProcouture_green, width: 1),
                      ),
                    ),
                    validator: (motPasse) {
                        if (motPasse!.isEmpty) {
                          return "Saisissez le mot de passe";
                        } else if (motPasse.length < 4) {
                          return "4 caractères au minimum";
                        } else if (motPasse.length > 10) {
                          return "10 caractères au maximum";
                        }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomFieldContainer(
                  height: textFieldHeight,
                  child: TextFormField(
                    controller: ctrlConfirmMotDePasse,
                    obscureText: obscureText2,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(obscureText2? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill),
                        onPressed: (){
                          setState(() {
                            obscureText2 = !obscureText2;
                          });
                        },
                      ),
                      icon: Icon(CupertinoIcons.lock_circle),
                      hintText: 'Confirmation du mot de passe',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none, // Enlever la bordure du bas
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: kProcouture_green, width: 1),
                      ),
                    ),
                    validator: (motPasseConfirm) {
                      if(motPasseConfirm!.isEmpty) {
                          return "Saisissez le mot de passe";
                        } else if (motPasseConfirm.length < 4) {
                          return "4 caractères au minimum";
                        } else if (motPasseConfirm.length > 10) {
                          return "10 caractères au maximum";
                        }
                    },
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height:textFieldHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 8, backgroundColor: kProcouture_green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),)),
                      onPressed: (){
                         if(_key.currentState!.validate() && ctrlMotDePasse.text == ctrlConfirmMotDePasse.text) {
                           Navigator.push(context, MaterialPageRoute(builder: (_) => AtelierPage()));
                         } else if (_key.currentState!.validate() && ctrlMotDePasse.text != ctrlConfirmMotDePasse.text){
                           Fluttertoast.showToast(msg: 'Mots de passe incorrect');
                           return;
                         }
                      },
                      child: textLato('Inscription', 17, Colors.white, TextAlign.center)
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

}
