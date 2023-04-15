import 'package:flutter/material.dart';

import '../../widgets/custom_text.dart';


class CnxInfo{
  static String? deviceName;
  static int? userID;
  static String? userLastName;
  static String? userFirstName;
  static String? userEmail;
  static int? atelierID;
  static String? token;
}

class Globals{
  /// Global variables
  static int modeleSource = 0;

  /// Global functions
  // Convert a french date to an english date
  static String? convertDateFrToEn(String dateValue){
    return ('${dateValue.substring(6,10)}-${dateValue.substring(3,5)}-${dateValue.substring(0,2)}');
  }
  // Convert a french date to an english date
  static String? convertDateEnToFr(String dateValue){
    return ('${dateValue.substring(8,10)}/${dateValue.substring(5,7)}/${dateValue.substring(0,4)}');
  }
}

void infoSnackBar(String text, BuildContext context, {bool closeButton = false}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: textLato('Veuillez renseigner les deux champs !', 12, Colors.white, TextAlign.start),
        elevation: 5.0,
        width: MediaQuery.of(context).size.width * .92,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        margin: const EdgeInsets.only(bottom: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        showCloseIcon: closeButton,
      )
  );
}

class GlobalSnackBar{
static showSnackbar(scaffoldKey, String msg) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(milliseconds: 1000),
      content: new Text(msg),
      backgroundColor: Colors.grey[800]));
}
}