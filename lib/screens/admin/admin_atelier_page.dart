import 'dart:convert';

import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:procouture/screens/admin/admin_atelier_home.dart';
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/screens/home/login.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'package:http/http.dart' as http;

import '../../components/message_box.dart';
import '../../models/Atelier.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/constants/color_constants.dart';
import 'admin_atelier_save_page.dart';

class AtelierPage extends StatefulWidget {
  String token;
  AtelierPage({Key? key, required this.token}) : super(key: key);

  @override
  State<AtelierPage> createState() => _AtelierPageState();
}

class _AtelierPageState extends State<AtelierPage> with SingleTickerProviderStateMixin{
  late FancyDrawerController _controller;
  bool isLoading = false;
  List<Atelier> allAteliers = [];

  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    getAllAteliers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return msgBoxCloseApp('Quitter l\'Application', 'Etes-vous sûre de bien vouloir quitter ?', context);
      },
      child: Material(
        child: FancyDrawerWrapper(
          backgroundColor: Colors.white,
          controller: _controller,
          cornerRadius: 13,
          itemGap: 0,
          drawerItems: <Widget>[
            DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.person, size: 32, color: Colors.black,),
                    ),
                    SizedBox(height: 10,),
                    textMontserrat("${CnxInfo.userFirstName} ${CnxInfo.userLastName}", 18, Colors.black, TextAlign.start,fontWeight: FontWeight.w600),
                  ],
                ),
            ),
            InkWell(
                onTap: () async {
                  _controller.close();
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAtelierSavePage(pageMode: 'A',)));
                  getAllAteliers();
                },
                splashColor: Colors.grey,
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: textMontserrat('Ajouter un atelier', 14, Colors.black, TextAlign.start),
                )
            ),
            InkWell(
                onTap: (){
                  _controller.close();
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
                },
                splashColor: Colors.grey,
                child: ListTile(
                  leading: Icon(Icons.monetization_on_rounded),
                  title: textMontserrat('Offres', 14, Colors.black, TextAlign.start),
                )
            ),
            InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
                },
                splashColor: Colors.grey,
                child: ListTile(
                  leading: Icon(Icons.logout_rounded),
                  title: textMontserrat('Se déconnecter', 14, Colors.black, TextAlign.start),
                )
            ),
            SizedBox(height: 200,)
          ],
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text('Ateliers',style: TextStyle(fontFamily: 'Montserrat', color: Colors.black,fontSize: 20),),
              centerTitle: true,
                leading: IconButton(
                  onPressed: (){
                    _controller.toggle();
                  }, icon: Icon(CupertinoIcons.line_horizontal_3, color: Colors.black,),
                )
            ),
            body: isLoading ? Center(child: CircularProgressIndicator()) : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                  itemCount: allAteliers.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAtelierHomePage(atelier: allAteliers[index],)));
                        },
                        child: Container(
                          height: 200,
                          margin: EdgeInsets.only(bottom: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [kDefaultBoxShadow]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 145,
                                  child: Row(
                                    children: [
                                      // Gérer le logo de l'atelier
                                      Container(
                                        width: 120,
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  100),
                                              border: Border.all(color: Colors.grey),
                                              image: DecorationImage(
                                                image: allAteliers[index].logo == null ? AssetImage('assets/images/No_image.png') as ImageProvider :
                                                    NetworkImage(allAteliers[index].logo!)
                                              )
                                          ),
                                        ),
                                      ),

                                      // Gérer les informations de l'atelier
                                      Expanded(
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Nom de l'atelier
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    textMontserrat(allAteliers[index].libelle!, 14, Colors.black, TextAlign.center,fontWeight: FontWeight.w500),
                                                    SizedBox(width: 10,),
                                                    Icon(CupertinoIcons.home, color: Colors.black45,),
                                                  ],
                                                ),
                                                // Ville
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    textMontserrat(allAteliers[index].pays!.libelle!, 14, Colors.black, TextAlign.center,fontWeight: FontWeight.w500),
                                                    SizedBox(width: 10,),
                                                    Icon(
                                                      CupertinoIcons.location_solid,
                                                      color: Colors.black45,),
                                                  ],
                                                ),
                                                // Pays
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    textMontserrat(allAteliers[index].tel_mobile != null ? allAteliers[index].tel_mobile! : '', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.w500),
                                                    SizedBox(width: 10,),
                                                    Icon(CupertinoIcons.device_phone_portrait,
                                                      color: Colors.black45,),
                                                  ],
                                                ),
                                                // Numero Telephone
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    textMontserrat(allAteliers[index].tel_fixe != null ? allAteliers[index].tel_fixe! : '', 14, Colors.black, TextAlign.center,fontWeight: FontWeight.w500),
                                                    SizedBox(width: 10,),
                                                    Icon(CupertinoIcons.phone_circle_fill, color: Colors.black45,),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 38,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.1)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      textMontserrat("Solde: ", 14, Colors.black, TextAlign.left,),
                                      textMontserrat("${NumberFormat('#,###', 'fr_FR').format(allAteliers[index].solde)} ${allAteliers[index].monnaie!.symbole}", 15,
                                          Colors.black, TextAlign.left, fontWeight: FontWeight.w700),
                                      /* SizedBox(width: 10,),
                                      textWorkSans('Clients: ', 13, Colors.black,
                                          TextAlign.left,
                                          fontWeight: FontWeight.w600),
                                      textWorkSans(
                                          '33', 13, Colors.black, TextAlign.left),
                                      SizedBox(width: 10,),
                                      textWorkSans('Employés: ', 13, Colors.black,
                                          TextAlign.left,
                                          fontWeight: FontWeight.w600),
                                      textWorkSans(
                                          '10', 13, Colors.black, TextAlign.left)*/
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
              ),
            ),
            /*floatingActionButton: FloatingActionButton.extended(
              backgroundColor: kProcouture_green,
              onPressed: (){},
                label: Row(
                  children: [
                    Icon(Icons.add),
                    textWorkSans(' Ajouter un Atelier', 12, Colors.white, TextAlign.left)
              ],
            )),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,*/
          ),
        ),
      ),
    );
  }

  void loadingProgress(bool value) {
    if (value) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getAllAteliers() async {

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_ateliers),
      headers: Globals.apiHeaders,
    );
    loadingProgress(false);

    if (response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);
      late Atelier atelier;
      allAteliers.clear();
      for (int i = 0; i < responseBody['data']['ateliers'].length; i++) { // Get all ateliers
        print(responseBody['data']['ateliers'][i]);
        atelier = Atelier.fromJson(responseBody['data']['ateliers'][i]);
        allAteliers.add(atelier);
      }
    }

  }

}
