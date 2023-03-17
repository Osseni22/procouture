import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procouture/screens/confection/client/client_mesure_page.dart';
import 'package:procouture/screens/confection/client/client_page.dart';
import 'package:procouture/screens/confection/client/client_rdv_page.dart';
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/screens/home/statistiques.dart';

import 'package:procouture/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commande/client_commande_page.dart';
import 'package:procouture/screens/confection/client/client_matiere_page.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({Key? key}) : super(key: key);

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String nomClient = 'Osseni Abdel Aziz le King';
  String tel1 = '+2250102030405';
  String tel2 = '+2250602030401';

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      backgroundColor: const Color(0xff223346),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg/Procouture_fond_session_client_compressed.png'),
                fit: BoxFit.cover
            )
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () {Navigator.pop(context);},
                          icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,)
                      ),
                      textLato('Session Client', 20, Colors.white, TextAlign.center),
                      IconButton(
                          onPressed: () {/*Navigator.of(context).push(MaterialPageRoute(builder: (_)=> HomePage()));*/},
                          icon: Icon(CupertinoIcons.home,color: Colors.white.withOpacity(0.0),)
                      ),
                    ]
                ),
                const SizedBox(height: 15),
                Container(
                  width: width,
                  height: width/2,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          opacity: 0.8,
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/ProCouture_Decor_Client_Session_compressed.png')
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xff223346),width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            spreadRadius: 2
                        )
                      ]
                  ),
                  child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        Positioned(
                          top: width/30,
                          right: 20,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 33,
                                width: 183,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(CupertinoIcons.person_solid,color: Colors.green,),
                                    SizedBox(width: 5,),
                                    textWorkSans((nomClient.length > 24) ? nomClient.substring(0,22).toUpperCase() : nomClient.toUpperCase(), 12, Colors.white, TextAlign.left)
                                  ],
                                ),
                              )
                          ),
                        ),
                        Positioned(
                          top: width/6,
                          right: 20,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 33,
                                width: 183,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(CupertinoIcons.phone,color: Colors.green,),
                                    SizedBox(width: 8,),
                                    textWorkSans('01 02 03 04 05 / 06 07 08 09'.substring(0,24), 12, Colors.white, TextAlign.left)
                                  ],
                                ),
                              )
                          ),
                        ),
                        Positioned(
                          top: width/3.2,
                          right: 20,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 33,
                                width: 183,
                                //color: Colors.blue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(CupertinoIcons.location_solid,color: Colors.green,),
                                    SizedBox(width: 8,),
                                    textWorkSans('Grand-Bassam'.toUpperCase(), 12, Colors.white, TextAlign.left)
                                  ],
                                ),
                              )                          ),
                        ),
                      ]
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  width: width,
                  height: width/2.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          HapticFeedback.mediumImpact();
                          showModalBottomSheet(
                              context: context,
                              builder: (ctx) => myBottomSheet(),
                            shape: const RoundedRectangleBorder( // <-- SEE HERE
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(17.0),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: width/2 - 10,
                          decoration: BoxDecoration(
                              color: Color(0xff223346).withOpacity(0.7),
                              border: Border.all(color: const Color(0xff223346), width: 2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    spreadRadius: 2
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textMontserrat('Contacter', 13, Colors.white, TextAlign.center),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.blue.withOpacity(0.7),
                                child: Icon(CupertinoIcons.phone_arrow_up_right, size: 29,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClientCommandePage()));
                        },
                        child: Container(
                          width: width/2 - 10,
                          decoration: BoxDecoration(
                              color: const Color(0xff223346).withOpacity(0.7),
                              border: Border.all(color: const Color(0xff223346), width: 2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    spreadRadius: 2
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textMontserrat('Commandes', 13, Colors.white, TextAlign.center),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.amber.withOpacity(0.7),
                                child: Icon(Icons.shopping_basket_rounded, size: 29,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  width: width,
                  height: width/2.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClientMesurePage()));
                        },
                        child: Container(
                          width: width/2 - 10,
                          decoration: BoxDecoration(
                              color: Color(0xff223346).withOpacity(0.7),
                              border: Border.all(color: const Color(0xff223346), width: 2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    spreadRadius: 2
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textMontserrat('Mesures', 13, Colors.white, TextAlign.center),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green.withOpacity(0.7),
                                child: Icon(CupertinoIcons.arrow_swap, size: 29,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClientRdvPage()));
                        },
                        child: Container(
                          width: width/2 - 10,
                          decoration: BoxDecoration(
                              color: Color(0xff223346).withOpacity(0.7),
                              border: Border.all(color: const Color(0xff223346), width: 2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    spreadRadius: 2
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textMontserrat('Rendez-vous', 13, Colors.white, TextAlign.center),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red.withOpacity(0.7),
                                child: Icon(CupertinoIcons.calendar_today, size: 29,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  width: width,
                  height: width/2.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClientMatierePage()));
                        },
                        child: Container(
                          width: width/2 - 10,
                          decoration: BoxDecoration(
                              color: Color(0xff223346).withOpacity(0.7),
                              border: Border.all(color: const Color(0xff223346), width: 2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    spreadRadius: 2
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textMontserrat('Matières', 13, Colors.white, TextAlign.center),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.purple.withOpacity(0.7),
                                child: Icon(CupertinoIcons.staroflife_fill, size: 29,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => Statistiques()));
                        },
                        child: Container(
                          width: width/2 - 10,
                          decoration: BoxDecoration(
                              color: Color(0xff223346).withOpacity(0.7),
                              border: Border.all(color: const Color(0xff223346), width: 2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    spreadRadius: 2
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textMontserrat('Statistiques', 13, Colors.white, TextAlign.center),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.cyanAccent.withOpacity(0.7),
                                child: Icon(CupertinoIcons.chart_pie_fill, size: 29,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Container myBottomSheet(){
    return Container(
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          textRaleway('Appeler le :', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
          //SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.45,
                child: OutlinedButton(
                  onPressed: () async{ _makePhoneCall(tel1);},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.phone, color: Colors.green, size: 18,),
                      textMontserrat(tel1, 14, Colors.green, TextAlign.center),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.45,
                child: OutlinedButton(
                  onPressed: () async{ _makePhoneCall(tel2);},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.phone, color: Colors.green, size: 18,),
                      textMontserrat(tel2, 14, Colors.green, TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}


