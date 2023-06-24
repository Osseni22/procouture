import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/widgets/custom_text.dart';

AppBar myDefaultAppBar(String title, BuildContext context,{double textSize = 16, Color bgColor = Colors.white, List<Widget> actions = const []}){
  return AppBar(
    title: textMontserrat(title, textSize, Colors.black, TextAlign.center,fontWeight: FontWeight.w500),
    centerTitle: true,
    elevation: 0.2,
    backgroundColor: bgColor,
    leading: IconButton(icon: Icon(Icons.arrow_back_ios_new),onPressed: () => Navigator.of(context).pop(),color: Colors.black,),
    actions: actions,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}
AppBar myBoutiqueAppBar(String title, BuildContext context,{double textSize = 18, List<Widget> actions = const []}){
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark
    ),
    title: textMontserrat(title, textSize, Colors.black, TextAlign.center),
    centerTitle: true,
    elevation: 0.2,
    backgroundColor: Colors.lightBlue,
    leading: IconButton(icon: Icon(Icons.arrow_back_ios_new),onPressed: () => Navigator.of(context).pop(),color: Colors.black,),
    actions: actions,
  );
}