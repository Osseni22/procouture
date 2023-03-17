import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/models/Produit.dart';

import '../../../widgets/default_app_bar.dart';

class CatalogueAlbum extends StatefulWidget {
  @override
  _CatalogueAlbumState createState() => new _CatalogueAlbumState();
}

class _CatalogueAlbumState extends State<CatalogueAlbum> {
  //double _page = 10;
  double _page = produits.length * 1.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    PageController pageController;
    //pageController = PageController(initialPage: 10);
    pageController = PageController(initialPage: produits.length);
    pageController.addListener(() {
        setState(() {
            _page = pageController.page!;
          },);
      },
    );

    return Scaffold(
      appBar: myDefaultAppBar('Album de modèles', context),
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: width + 150,
              width: width * 0.99,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  List<Widget> cards = [];

                  //for (int i = 0; i <= 11; i++) {
                  for (int i = 0; i <= produits.length-1; i++) {
                    double currentPageValue = i - _page;
                    bool pageLocation = currentPageValue > 0;

                    double start = 20 +
                        max(
                            (boxConstraints.maxWidth - width * .75) -
                                ((boxConstraints.maxWidth - width * .75) / 2) *
                                    -currentPageValue *
                                    (pageLocation ? 9 : 1),
                            0.0);

                    var customizableCard = Positioned.directional(
                      top: 20 + 30 * max(-currentPageValue, 0.0),
                      bottom: 20 + 30 * max(-currentPageValue, 0.0),
                      start: start,
                      textDirection: TextDirection.ltr,
                      child: Container(
                          height: width * .70,
                          width: width * .70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                //image: AssetImage('assets/images/chemise1.jpg')
                                image: AssetImage(produits[i].image!)
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.15),
                                    blurRadius: 10)
                              ])),
                    );
                    cards.add(customizableCard);
                  }
                  return Stack(children: cards);
                },
              ),
            ),
            Positioned.fill(
              child: PageView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                //itemCount: 11,
                itemCount: produits.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}