import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/screens/home/login.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'dart:io' show Platform, exit;

Future<bool> msgBoxYesNo(String titleText, String contentText, BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: textMontserrat(titleText,16,Colors.black,TextAlign.start,fontWeight: FontWeight.w600),
      content: textMontserrat(contentText,14,Colors.black,TextAlign.start),
      shape: const RoundedRectangleBorder( // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
          bottom: Radius.circular(10.0),
        ),
      ),
      actions: <Widget>[
        Container(
          width: 100,
          height: 40,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.1)
            ),
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: textMontserrat('Non',13,Colors.black,TextAlign.start, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: 100,
          height: 40,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.2)
            ),
            onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
            child:textMontserrat('Oui',13,Colors.green.withOpacity(0.6),TextAlign.start, fontWeight: FontWeight.w800),

          ),
        ),
      ],
    ),
  )
  ) ?? false;
}

Future<bool> msgBoxOk(String titleText, String contentText, BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
          child: Text('Ok'),
        ),
      ],
    ),
  )
  ) ?? false;
}

Future<bool> msgBoxLanguageChoiceSubmitCancel(BuildContext context) async {
  bool isEnglish = false;
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Choix de la langue'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Image(image: AssetImage('assets/images/french-flag.png'), height: 50,width: 50,),
          CupertinoSwitch(
              value: isEnglish,
              activeColor: Colors.red,
              onChanged: (bool value){
                isEnglish = value;
              }
          ),
          const Image(image: AssetImage('assets/images/english-flag.png'),height: 60,width: 60,),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if(isEnglish){
              // Mettre les préferences
              Navigator.of(context).pop(true);
            } else {
              // Mettre les préferences
              Navigator.of(context).pop(true);
            }
          } , // <-- SEE HERE
          child: Text('Valider'),
        ),
      ],
    ),
  )
  ) ?? false;
}

// Boîte de dialogue pour fermer l'application
Future<bool> msgBoxCloseApp(String titleText, String contentText, BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
          child: Text('Non'),
        ),
        ElevatedButton(
          //onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
            child: Text('Oui'),
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            }
        ),
      ],
    ),
  )
  ) ?? false;
}
// Boîte de dialogue pour fermer l'application
Future<bool> msgBoxLogOut(BuildContext context) async {
  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      //title: Text(titleText),
      content: Text('Se déconnecter ?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
          child: Text('Non'),
        ),
        ElevatedButton(
          //onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
            child: Text('Oui'),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
            }
        ),
      ],
    ),
  )
  ) ?? false;
}

