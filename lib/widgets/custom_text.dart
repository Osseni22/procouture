import 'package:flutter/material.dart';

Text textLato(String textString, double size, Color color, TextAlign textAlign,
    {FontWeight fontWeight = FontWeight.normal, TextDecoration decoration = TextDecoration.none}){
  return Text(
    textString,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'Lato',
      fontWeight: fontWeight,
      decoration: decoration,
    ),
    overflow: TextOverflow.ellipsis
  );
}

Text textMontserrat(String textString, double size, Color color, TextAlign textAlign,
    {FontWeight fontWeight = FontWeight.normal, TextDecoration decoration = TextDecoration.none}){
  return Text(
    textString,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'Montserrat',
      fontWeight: fontWeight,
      decoration: decoration,
    ),
  );
}

Text textOpenSans(String textString, double size, Color color, TextAlign textAlign,
    {FontWeight fontWeight = FontWeight.normal, TextDecoration decoration = TextDecoration.none}){
  return Text(
    textString,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'Open Sans',
      fontWeight: fontWeight,
      decoration: decoration,
    ),
  );
}

Text textRaleway(String textString, double size, Color color, TextAlign textAlign,
    {FontWeight fontWeight = FontWeight.normal, TextDecoration decoration = TextDecoration.none}){
  return Text(
    textString,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'Raleway',
      fontWeight: fontWeight,
      decoration: decoration,
    ),
  );
}

Text textWorkSans(String textString, double size, Color color, TextAlign textAlign,
    {FontWeight fontWeight = FontWeight.normal, TextDecoration decoration = TextDecoration.none}){
  return Text(
    textString,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontFamily: 'Work Sans',
      fontWeight: fontWeight,
      decoration: decoration,
    ),
  );
}