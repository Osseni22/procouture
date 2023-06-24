import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/models/Produit.dart';
import 'package:procouture/models/Product.dart';

import '../../../utils/globals/global_var.dart';
import '../../../widgets/default_app_bar.dart';
import '../product/product_view_page.dart';

class CatalogueAlbum extends StatefulWidget {
  final List<Product> product;
  const CatalogueAlbum({super.key, required this.product});

  @override
  _CatalogueAlbumState createState() => _CatalogueAlbumState();
}

class _CatalogueAlbumState extends State<CatalogueAlbum> {
  //double _page = 10;
  double _page = Globals.albumLength * 1.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    PageController pageController;
    //pageController = PageController(initialPage: 10);
    pageController = PageController(initialPage: widget.product.length);
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
                  for (int i = 0; i <= widget.product.length-1; i++) {
                    double currentPageValue = i - _page;
                    bool pageLocation = currentPageValue > 0;

                    double start = 20 + max((boxConstraints.maxWidth - width * .75) -
                                ((boxConstraints.maxWidth - width * .75) / 2) * -currentPageValue * (pageLocation ? 9 : 1), 0.0);

                    var customizableCard = Positioned.directional(
                      top: 20 + 30 * max(-currentPageValue, 0.0),
                      bottom: 20 + 30 * max(-currentPageValue, 0.0),
                      start: start,
                      textDirection: TextDirection.ltr,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ProductViewPage(image_av: widget.product[i].image_av, image_ar: widget.product[i].image_ar)));
                        },
                        child: Container(
                            height: width * .70,
                            width: width * .70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(widget.product[i].image_av!)
                                  //image: AssetImage(widget.product[i].image_av!)
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(.15),
                                      blurRadius: 10)
                                ])),
                      ),
                    );
                    cards.add(customizableCard);
                  }
                  return Stack(children: cards);
                },
              ),
            ),
            Positioned.fill(
              child: PageView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                //itemCount: 11,
                itemCount: widget.product.length,
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