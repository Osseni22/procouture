import 'package:flutter/material.dart';

Text textLato(String string, double size, Color color, TextAlign textAlign, {FontWeight fontWeight = FontWeight.normal}){
  return Text(
    string,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'Lato',
      fontWeight: fontWeight,
    ),
  );
}

Text textMontserrat(String string, double size, Color color, TextAlign textAlign, {FontWeight fontWeight = FontWeight.normal}){
  return Text(
    string,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: 'Montserrat',
      fontWeight: fontWeight,
    ),
  );
}

Text textOpenSans(String string, double size, Color color, TextAlign textAlign, {FontWeight fontWeight = FontWeight.normal}){
  return Text(
    string,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: 'Open Sans',
      fontWeight: fontWeight,
    ),
  );
}

Text textRaleway(String string, double size, Color color, TextAlign textAlign, {FontWeight fontWeight = FontWeight.normal}){
  return Text(
    string,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: 'Raleway',
      fontWeight: fontWeight,
    ),
  );
}

Text textWorkSans(String string, double size, Color color, TextAlign textAlign, {FontWeight fontWeight = FontWeight.normal}){
  return Text(
    string,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: 'Work Sans',
        fontWeight: fontWeight,
    ),
  );
}