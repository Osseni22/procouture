import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/default_box_shadow.dart';

class AtelierPage extends StatefulWidget {
  const AtelierPage({Key? key}) : super(key: key);

  @override
  State<AtelierPage> createState() => _AtelierPageState();
}

class _AtelierPageState extends State<AtelierPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myDefaultAppBar('Ateliers', context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: 3,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())); },
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
                                  borderRadius: BorderRadius.circular(100),
                                  //border: Border.all(color: Colors.grey),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/appstore.png')
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
                                          textOpenSans('Nom de l\'atelier ${index + 1}', 14, Colors.black, TextAlign.center),
                                          SizedBox(width: 10,),
                                          Icon(CupertinoIcons.home, color: Colors.black45,),

                                        ],
                                      ),
                                      // Ville
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          textOpenSans('Ville de l\'Atelier ${index + 1}', 14, Colors.black, TextAlign.center),
                                          SizedBox(width: 10,),
                                          Icon(CupertinoIcons.location_solid, color: Colors.black45,),

                                        ],
                                      ),
                                      // Pays
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          textOpenSans('Pays de l\'Atelier ${index + 1}', 14, Colors.black, TextAlign.center),
                                          SizedBox(width: 10,),
                                          Icon(CupertinoIcons.flag, color: Colors.black45,),
                                        ],
                                      ),
                                      // Numero Telephone
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          textOpenSans('+225 00 99 00 99 00', 14, Colors.black, TextAlign.center),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            textWorkSans('Commandes: ', 13, Colors.black, TextAlign.left, fontWeight: FontWeight.w600),
                            textWorkSans('40', 13, Colors.black, TextAlign.left,),
                            SizedBox(width: 10,),
                            textWorkSans('Clients: ', 13, Colors.black, TextAlign.left, fontWeight: FontWeight.w600),
                            textWorkSans('33', 13, Colors.black, TextAlign.left),
                            SizedBox(width: 10,),
                            textWorkSans('Employés: ', 13, Colors.black, TextAlign.left, fontWeight: FontWeight.w600),
                            textWorkSans('10', 13, Colors.black, TextAlign.left)
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
      floatingActionButton: FloatingActionButton.extended(onPressed: (){}, label: Row(
        children: [
          Icon(Icons.add),
          textWorkSans(' Ajouter un Atelier', 12, Colors.white, TextAlign.left)
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
