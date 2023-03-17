import 'package:flutter/material.dart';
import 'package:procouture/widgets/default_app_bar.dart';


class ArticleViewPage extends StatelessWidget {
  final imagePath;
  const ArticleViewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: myBoutiqueAppBar("Affichage de l'article", context),
      body: Center(
        child: Container(
          height: _size - 10,
          width: _size - 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //border: Border.all(),
              image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain
              )
          ),
          //child: PhotoView(imageProvider: AssetImage(imagePath)),
        ),
      ),
    );
  }
}
