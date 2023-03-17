import 'package:flutter/material.dart';
import 'package:procouture/widgets/default_box_shadow.dart';

Widget CustomFieldContainer({required Widget child, double height = 50.0}){
  return Container(
    height: height,
    padding: EdgeInsets.only(left: 4.0),
    alignment: Alignment.centerLeft,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
        //boxShadow: [kDefaultBoxShadow3]
    ),
    child: child,
  );
}