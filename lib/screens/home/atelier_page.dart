import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:procouture/screens/home/atelier_users_page.dart';
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'package:http/http.dart' as http;

import '../../models/Atelier.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/constants/color_constants.dart';

class AtelierPage extends StatefulWidget {
  String token;
  AtelierPage({Key? key, required this.token}) : super(key: key);

  @override
  State<AtelierPage> createState() => _AtelierPageState();
}

class _AtelierPageState extends State<AtelierPage> {
  bool isLoading = false;
  List<Atelier> allAteliers = [];

  @override
  void initState() {
    getAllAteliers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Ateliers', context),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
            itemCount: allAteliers.length,
            itemBuilder: (BuildContext context, int index) =>
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AtelierUsersPage(atelier: allAteliers[index],)));
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
                                        //border: Border.all(color: Colors.grey),
                                        image: DecorationImage(image: AssetImage('assets/images/appstore.png'))
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
                                              textOpenSans(allAteliers[index].libelle!, 14, Colors.black, TextAlign.center),
                                              SizedBox(width: 10,),
                                              Icon(CupertinoIcons.home, color: Colors.black45,),
                                            ],
                                          ),
                                          // Ville
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              textOpenSans(allAteliers[index].pays!.libelle!, 14, Colors.black, TextAlign.center),
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
                                              textOpenSans(allAteliers[index].tel_mobile != null ? allAteliers[index].tel_mobile! : 'Inconnu', 14, Colors.black, TextAlign.center),
                                              SizedBox(width: 10,),
                                              Icon(CupertinoIcons.device_phone_portrait,
                                                color: Colors.black45,),
                                            ],
                                          ),
                                          // Numero Telephone
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              textOpenSans(allAteliers[index].tel_fixe != null ? allAteliers[index].tel_fixe! : 'Inconnu', 14, Colors.black, TextAlign.center),
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
                                textWorkSans('Solde: ', 13, Colors.black, TextAlign.left, fontWeight: FontWeight.w600),
                                textWorkSans(allAteliers[index].solde.toString(), 13, Colors.black, TextAlign.left,),
                                /*SizedBox(width: 10,),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kProcouture_green,
        onPressed: () {},
          label: Row(
            children: [
              Icon(Icons.add),
              textWorkSans(' Ajouter un Atelier', 12, Colors.white, TextAlign.left)
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
    String token = widget.token;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_ateliers),
      headers: myHeaders,
    );
    loadingProgress(false);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      late Atelier atelier;

      for (int i = 0; i < responseBody['data']['ateliers'].length; i++) { // Get all ateliers
        print('///////////');
        print(responseBody['data']['ateliers'][i]);
        atelier = Atelier.fromJson(responseBody['data']['ateliers'][i]);
        allAteliers.add(atelier);
      }

    }
  }

}
