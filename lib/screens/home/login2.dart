import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/screens/home/login.dart';

import '../../services/api_routes/routes.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/globals/global_var.dart';
import '../../widgets/custom_text.dart';
import '../admin/admin_atelier_page.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({Key? key}) : super(key: key);

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {

  bool isChecked = false;
  bool isConnecting = false;
  bool isAdmin = false;

  String? emailUsername;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green.withOpacity(0.1),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            /*Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){ Navigator.pop(context);},
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.close, color: Colors.black,),
                ),
              ),
            ],
          ),*/
            Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(CupertinoIcons.person_fill, color: Colors.black45,size: 40,),
                      ),
                      SizedBox(height: 10,),
                      textRaleway(Globals.emailUsername != null ? Globals.emailUsername! : '', 19, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
                      SizedBox(height: 50,),
                      GestureDetector(
                        onTap: (){
                          if(Globals.isAdmin != null && Globals.isAdmin == true){
                            loginAdmin(Globals.emailUsername!, Globals.password!, 'mobile', CnxInfo.deviceName!);
                          } else {
                            login(Globals.emailUsername!, Globals.password!, 'mobile', CnxInfo.deviceName!);
                          }
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: kProcouture_green
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              textMontserrat('Se connecter', 14, Colors.white, TextAlign.start),
                              isConnecting? const SizedBox(width: 10,) : const SizedBox(),
                              isConnecting? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                              ): const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.transparent,
                              border: Border.all(color: Colors.black)
                          ),
                          child: textMontserrat("Se connecter à un autre compte", 14, Colors.black, TextAlign.start),
                        ),
                      ),
                      //SizedBox(height: 100,)
                    ],
                  ),
                )
            ),
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/appstore.png')
                      )
                    ),
                  ),
                  SizedBox(width: 10,),
                  textMontserrat('ProCouture', 14, Colors.black, TextAlign.start, fontWeight: FontWeight.w500)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startLoading(){
    setState(() {
      isConnecting = true;
    });
  }
  void endLoading(){
    setState(() {
      isConnecting = false;
    });
  }

  Future<void> login (String username, String password, String role, String deviceName) async {
    Map data = {
      'username': username,
      'password': password,
      'role': role,
      'device_name': deviceName
    };
    //print(data.toString());
    startLoading();
    final response = await http.post(
        Uri.parse(r_login),
        body: data,
        encoding: Encoding.getByName("utf-8")
    );
    endLoading();

    // Create a JSON decoder object
    final jsonDecoder = JsonDecoder();
    // Decode the JSON data into a Map<String, dynamic> object
    final jsonMap = jsonDecoder.convert(response.body);
    print(jsonMap);

    if (response.statusCode == 200){

      // Extract data from the nested JSON object
      CnxInfo.userID = jsonMap['user']['id'];
      CnxInfo.userEmail = jsonMap['user']['email'];
      CnxInfo.userFirstName = jsonMap['user']['prenom'];
      CnxInfo.userLastName = jsonMap['user']['nom'];
      CnxInfo.atelierID = jsonMap['user']['atelier_id'];
      CnxInfo.token = jsonMap['token'];
      CnxInfo.symboleMonnaie = jsonMap['user']['atelier']['monnaie']['symbole'];
      CnxInfo.atelierLibelle = jsonMap['user']['atelier']['libelle'];

      print(CnxInfo.symboleMonnaie);
      print(CnxInfo.atelierLibelle);
      print(CnxInfo.token);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else if (response.statusCode == 422){
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
      //Fluttertoast.showToast(msg: '${jsonMap['errors']['username']}');
    } else {
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
      //Fluttertoast.showToast(msg: '${jsonMap['errors']['username']}');
    }
  }

  Future<void> loginAdmin(String email, String password, String role, String deviceName) async {
    Map data = {
      'email': email,
      'password': password,
      'role': role,
      'device_name': deviceName
    };
    startLoading();
    final response = await http.post(
        Uri.parse(AdminRoutes.r_adminLogin),
        body: data,
        encoding: Encoding.getByName("utf-8")
    );
    endLoading();

    // Create a JSON decoder object
    final jsonDecoder = JsonDecoder();

    // Decode the JSON data into a Map<String, dynamic> object
    final jsonMap = jsonDecoder.convert(response.body);

    //print(jsonMap);

    if (response.statusCode == 200){

      // Extract data from the nested JSON object
      CnxInfo.userID = jsonMap['user']['id'];
      CnxInfo.userEmail = jsonMap['user']['email'];
      CnxInfo.userFirstName = jsonMap['user']['prenom'];
      CnxInfo.userLastName = jsonMap['user']['nom'];
      CnxInfo.atelierID = jsonMap['user']['atelier_id'];
      CnxInfo.token = jsonMap['token'];


      print(CnxInfo.token);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AtelierPage(token: CnxInfo.token!)));

    } else if (response.statusCode == 422){
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
    } else {
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
    }
  }

}
