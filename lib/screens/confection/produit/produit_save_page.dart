import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class ProduitSave extends StatefulWidget {
  const ProduitSave({Key? key}) : super(key: key);

  @override
  State<ProduitSave> createState() => _ProduitSaveState();
}

class _ProduitSaveState extends State<ProduitSave> {
  // Toutes les categories de vêtements
  List<String> items_catalogues = [
    'Chemises',
    'Pantalons',
    'Vestes',
    'Gilets',
    'Tuniques',
    'Robe',
    'Cravate'
  ];
  String? catalogueValue;
  String firstCatalogueItem() {
    return items_catalogues[0];
  }

  // Liste lieu d'enregistrement des produits
  List<String> items_enreg_dans = [
    'Confection et boutique',
    'Confection',
    'Boutique'
  ];
  String? enreg_dans;
  String firstEnregDans() {
    return items_enreg_dans[0];
  }

  // Variables pour les images
 /* PickedFile? myImageFile;
  File? _imageFile;
  final _picker = ImagePicker();*/

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  void takePicture(ImageSource source) async {
    final pickleFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickleFile;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Fiche Modèle', context),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gestion des images
                Container(
                  height: 300,
                  width: double.infinity,
                  alignment: Alignment.center,
                  //color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image du produit
                          textRaleway('Image Avant', 14, Colors.black, TextAlign.center),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade400),
                                    image: DecorationImage(
                                        image: _imageFile == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFile!.path)),
                                        fit: BoxFit.cover
                                    )
                                ),
                                //child: _imageFile == null ? Image.asset('assets/images/shirt_logo.png',fit: BoxFit.cover) : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                              )
                            ],
                          ),
                          SizedBox(height: 5,),
                          // Image de selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    takePicture(ImageSource.camera);
                                  },
                                  icon: Icon(Icons.photo_camera, color: Colors.grey.shade500,),
                                ),
                              ),
                              const SizedBox(width: 15,),
                              Container(
                                height: 40,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    takePicture(ImageSource.gallery);
                                  },
                                  icon: Icon(Icons.photo, color: Colors.grey.shade500),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image du produit
                          textRaleway('Image Arrière', 14, Colors.black, TextAlign.center),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade400),
                                    image: DecorationImage(
                                        image: _imageFile == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFile!.path)),
                                        fit: BoxFit.cover
                                    )
                                ),
                                //child: _imageFile == null ? Image.asset('assets/images/shirt_logo.png',fit: BoxFit.cover) : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                              )
                            ],
                          ),
                          const SizedBox(height: 5,),
                          // Image de selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    takePicture(ImageSource.camera);
                                  },
                                  icon: Icon(Icons.photo_camera, color: Colors.grey.shade500,),
                                ),
                              ),
                              const SizedBox(width: 15,),
                              Container(
                                height: 40,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey.withOpacity(0.5))
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    takePicture(ImageSource.gallery);
                                  },
                                  icon: Icon(Icons.photo, color: Colors.grey.shade500),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                // Champs de saisie
                Container(
                  height: 270,
                  padding:  EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 10)
                        )
                      ]
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          //controller: ,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Désignation',
                              hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: TextField(
                          //controller: ,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Quantité',
                              hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: textMontserrat('Choisir une catégorie',16,Colors.grey,TextAlign.left),
                          value: catalogueValue,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          items: items_catalogues.map((String items_value) {
                            return DropdownMenuItem(
                              value: items_value,
                              child: textMontserrat(items_value,16,Colors.black, TextAlign.left),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              catalogueValue = newValue!;
                            });
                          },
                        ),
                      ),

                      // Lieu d'enregistrement
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: textMontserrat('Où enregistrer',16,Colors.grey,TextAlign.left),
                          value: enreg_dans,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          items: items_enreg_dans.map((String itemsValue) {
                            return DropdownMenuItem(
                              value: itemsValue,
                              child: textMontserrat(itemsValue,16,Colors.black, TextAlign.left),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              enreg_dans = newValue!;
                            });
                          },
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 25,),
                GestureDetector(
                  onTap: (){print('OK');},
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: double.infinity,
                    padding:  EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: kProcouture_green,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 10)
                          )
                        ]
                    ),
                    child: textMontserrat('Valider', 18, Colors.white, TextAlign.center),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  /*Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }*/
}
