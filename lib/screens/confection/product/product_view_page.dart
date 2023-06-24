import 'package:flutter/material.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/Product.dart';
import '../../../widgets/custom_text.dart';

class ProductViewPage extends StatelessWidget {
  final String? image_av;
  final String? image_ar;
  const ProductViewPage({Key? key, required this.image_av,required this.image_ar}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var _size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: myDefaultAppBar('Affichage du modèle', context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              textRaleway('Avant du modèle', 16, Colors.black, TextAlign.center),
              const SizedBox(height: 10,),
              Container(
                height: _size - 10,
                width: _size - 10,
                /*decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  //border: Border.all(),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain
                  )
                ),*/
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PhotoView(imageProvider: image_av != null? NetworkImage( image_av!): AssetImage('assets/images/shirt_logo.png') as ImageProvider)
                ),
              ),
              const SizedBox(height: 10,),
              textRaleway('Arrière du modèle', 16, Colors.black, TextAlign.center),
              const SizedBox(height: 10,),
              Container(
                height: _size - 10,
                width: _size - 10,
                /*decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                      fit: BoxFit.contain
                  )
                ),*/
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PhotoView(imageProvider: image_ar != null? NetworkImage( image_ar!): AssetImage('assets/images/shirt_logo.png') as ImageProvider)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
