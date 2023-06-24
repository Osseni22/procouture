import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:procouture/models/Produit.dart';
import 'package:procouture/screens/confection/product/product_view_page.dart';
import 'package:procouture/screens/confection/product/product_save_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'package:http/http.dart' as http;

import '../../../components/message_box.dart';
import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';
import '../../../widgets/default_app_bar.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {

  //List<String> familles = ['Toutes','Chemise','Pantalon','Robe','Veste','Tunique'];
  int? selectedIndex;
  bool isLoading = false;

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> productsByCategorie = [];

  @override
  void initState() {
    selectedIndex = 0;
    getProductsList(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Catalogue', context),
      body: isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent) : Column(
        children: [
          //isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 15),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex = index;
                            runFilter(categories[index]['id'].toString());
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: index == selectedIndex ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: index == selectedIndex ? Border.all(color: Colors.grey, width: 1) : Border.all(color: Colors.transparent, width: 0),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: textRaleway(categories[index]['libelle'], 15,Colors.black, TextAlign.start)
                        ),
                      )
              ),
            ),
          ),
          const SizedBox(height: 15,),

          /// Modeles views
          Expanded(
              child: productsByCategorie.isNotEmpty?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Container(
                  color: Colors.transparent,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: productsByCategorie.length,
                      itemBuilder: (BuildContext context, int currentIndex) => Stack(
                        children: [
                          Container(
                            height: 170,
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: (currentIndex % 2 == 0) ? Colors.orangeAccent.withOpacity(0.7): Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(22),
                              //boxShadow: [kDefaultBoxShadow],
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 13,
                              left:22,
                              child: GestureDetector(
                                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) => ProductViewPage(image_av: productsByCategorie[currentIndex]['image_av'],image_ar: productsByCategorie[currentIndex]['image_ar'])));},
                                child: Container(
                                  height: 144,
                                  width: 108,
                                  //padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      //border: Border.all(),
                                      image: DecorationImage(
                                        image: productsByCategorie[currentIndex]['image_av'] != null ?
                                              NetworkImage(productsByCategorie[currentIndex]['image_av'],
                                                //errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) => Icon(Icons.error),
                                              )
                                            : AssetImage('assets/images/shirt_logo.png') as ImageProvider,
                                        fit: BoxFit.cover,

                                      )
                                  ),
                                  //child: Image.asset('assets/images/chemise1.jpg',fit: BoxFit.cover,),
                                ),
                              )
                          ),
                          Positioned(
                              bottom: 15,
                              right: 0,
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 4),
                                height: 40,
                                width: 160,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent.withOpacity(0.7),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(22),
                                        bottomRight: Radius.circular(22)
                                    )
                                ),
                                child: textMontserrat('${NumberFormat('#,###', 'fr_FR').format(productsByCategorie[currentIndex]['prix_ht'])} ${CnxInfo.symboleMonnaie}', 17, Colors.black, TextAlign.start),
                              )
                          ),
                          Positioned(
                              top: 13,
                              left:140,
                              child: Container(
                                height: 115,
                                width: 160,
                                alignment: Alignment.centerLeft,
                                child: textRaleway(productsByCategorie[currentIndex]['libelle'], 16, Colors.black, TextAlign.start),
                              )
                          ),
                          Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                height: 120,
                                width: 45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.grey[100],
                                        child: IconButton(
                                          onPressed: () async {
                                            await Navigator.push(context, MaterialPageRoute(builder: (context) => ProduitSave(pageMode: 'M', categories: categories, productMap: productsByCategorie[currentIndex],)));
                                            getProductsList(true);
                                          },
                                          icon: Icon(Icons.edit_note_rounded),color: Colors.black,)
                                    ),
                                    CircleAvatar(
                                        backgroundColor: Colors.grey[100],
                                        child: IconButton(
                                          onPressed: () async{
                                            if(await msgBoxYesNo('Confirmation ', 'Supprimer ce modèle ?', context)){
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await Future.delayed(Duration(seconds: 2));
                                              //print('Le client ${currentIndex+1} Supprimé');
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else {
                                              //print('Le client ${currentIndex+1} pas supprimé');
                                            };
                                          },
                                          icon: Icon(CupertinoIcons.delete_solid),color: Colors.black,)
                                    ),
                                  ],
                                ),
                              )
                          )
                        ],
                      )
                  ),
                ),
              ) : Center( child:Text('Aucun modèle pour la catégorie selectionnée'))
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => ProduitSave(pageMode: 'A', categories: categories)));
            getProductsList(true);
          },
          child : Icon(CupertinoIcons.add)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  /// TRAITEMENTS
  void loadingProgress(bool value){
    if(value){
      setState(() { isLoading = true;});
    } else {
      setState(() { isLoading = false;});
    }
  }

  Future<void> getProductsList(bool includeCategorieVetement) async {
    String token = CnxInfo.token!;
    String bearerToken = 'Bearer $token';

    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': bearerToken
    };

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_product),
      headers: myHeaders,
    );
    loadingProgress(false);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      categories.clear();
      products.clear();
      for(int i = 0; i < responseBody['data']['categorie_vetements'].length; i++){
        Map<String, dynamic> dataMap = {
          "id": responseBody['data']['categorie_vetements'][i]['id'],
          "libelle": responseBody['data']['categorie_vetements'][i]['libelle'],
        };
        categories.add(dataMap);

        for(int j = 0; j < responseBody['data']['categorie_vetements'][i]['catalogues'].length; j++){
          //print(responseBody['data']['categorie_vetements'][i]['catalogues'].length);
          Map<String, dynamic> dataMap2 = {
            "id": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['id'],
            "ref": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['ref'],
            "libelle": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['libelle'],
            "prix_ht": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['prix_ht'],
            "image_av": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['image_av'],
            "image_ar": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['image_ar'],
            "categorie_vetement_id": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['categorie_vetement_id'],
            "base_modele_id": responseBody['data']['categorie_vetements'][i]['catalogues'][j]['base_id'],
          };
          products.add(dataMap2);
        }
      }
    }
    //productsByCategorie = products;
    runFilter(categories[selectedIndex!]['id'].toString());
  }

  void runFilter(String categorie_id) {
    List<Map<String, dynamic>> results = [];
    for(int i = 0; i < products.length; i++){
      if(products[i]['categorie_vetement_id'].toString() == categorie_id){
        results.add(products[i]);
      }
    }
    productsByCategorie = results;
  }

}
