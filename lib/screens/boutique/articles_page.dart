import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:procouture/models/Produit.dart';
import 'package:procouture/screens/boutique/articles_save_page.dart';
import 'package:procouture/widgets/default_app_bar.dart';

import '../../components/message_box.dart';
import '../../widgets/custom_text.dart';
import 'package:procouture/screens/boutique/article_view_page.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<String> familles = ['Toutes','Chemise','Pantalon','Robe','Veste','Tunique'];
  int selectedIndex = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myBoutiqueAppBar('Articles', context),
      body: Column(
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent) : SizedBox(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 15),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: familles.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: index == selectedIndex? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: index == selectedIndex? Border.all(color: Colors.grey, width: 1) : Border.all(color: Colors.transparent, width: 0),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: textRaleway(familles[index], 15,Colors.black, TextAlign.start)
                        ),
                      )
              ),
            ),
          ),
          const SizedBox(height: 15,),
          Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 13),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  mainAxisExtent: 260,
                ),
                itemCount: produits.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            spreadRadius: 2
                        )
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleViewPage(imagePath: produits[index].image!,)));},
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                          child: Image.asset(
                              produits[index].image!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 6, top: 2, bottom: 2, right: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textRaleway(produits[index].libelle!, 11, Colors.black, TextAlign.start),
                                    const SizedBox(height: 5,),
                                    textMontserrat("${produits[index].prix.toString()} FCFA", 13, Colors.brown, TextAlign.start,fontWeight: FontWeight.bold),
                                  ],
                                ),
                              ),
                              Container(
                                width: 30,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        radius: 17,
                                        backgroundColor: Colors.grey[100],
                                        child: IconButton(
                                          onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleSavePage())); },
                                          icon: Icon(Icons.edit_note_rounded),color: Colors.black,iconSize: 17,)
                                    ),
                                    //const SizedBox(width: 5,),
                                    CircleAvatar(
                                        radius: 17,
                                        backgroundColor: Colors.grey[100],
                                        child: IconButton(
                                          onPressed: () async{
                                            if(await msgBoxYesNo('Confirmation ', 'Supprimer cet article ?', context)){
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await Future.delayed(Duration(seconds: 2));
                                              print('Article ${index+1} Supprimé');
                                              setState(() {
                                                isLoading = false;
                                              });
                                            } else {
                                              print('Article ${index+1} pas supprimé');
                                            };
                                          },
                                          icon: Icon(CupertinoIcons.delete_solid),color: Colors.black,iconSize: 17,)
                                    ),
                                  ],
                                )
                                ,
                              )
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                )
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 8,
        onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleSavePage()));},
        child : Icon(CupertinoIcons.add,color: Colors.black)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
