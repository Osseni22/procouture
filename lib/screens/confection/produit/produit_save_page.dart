import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../services/api_routes/routes.dart';
import '../../../utils/globals/global_var.dart';

class ProduitSave extends StatefulWidget {
  // Mode d'ouverture de la page : Ajout ou modification
  final String pageMode;
  // Récuperer toutes les categories de vêtement depuis la page précédente
  List<Map<String, dynamic>> categories;
  // Récuperer les informations du modèle en question en cas de modification
  Map<String, dynamic>? productMap;
  ProduitSave({Key? key, required this.pageMode, required this.categories, this.productMap}) : super(key: key);

  @override
  State<ProduitSave> createState() => _ProduitSaveState();
}

class _ProduitSaveState extends State<ProduitSave> {
  // Toutes les categories de vêtements
  List<Map<String, dynamic>> itemsCategories = [];
  String? categorieValue;
  String categorieValueHolder = '';

  // Liste lieu d'enregistrement des produits
  List<String> itemsBaseModele = [
    'Confection',
    'Boutique',
    'Confection et boutique',
  ];
  String? baseModeleValue;

  /// CONTROLLERS
  TextEditingController designationCtrl = TextEditingController();
  TextEditingController prixHtCtrl = TextEditingController();

  /// LOADING STATE
  var isLoading = false;

  File? _imageFileAv;
  File? _imageFileAvCompressed;
  final _picker = ImagePicker();

  Future<void> takeFirstPicture(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        _imageFileAv = File(pickedFile!.path);
        /*print("CATEGORIE ID ${getCategorieVetementId()}");
        print("CATEGORIE STRING ${itemsCategories[0]['libelle']}");
        print("CATEGORIEHOLDER $categorieValueHolder");
        print("BASE MODELE ${getBaseModele()}");
        //print(" ${getBaseModele()}");*/
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  File? _imageFileAr;
  File? _imageFileArCompressed;
  final _pickerAr = ImagePicker();

  Future<void> takeSecondPicture(ImageSource source) async {
    try{
      final pickedFile = await _pickerAr.pickImage(source: source);
      setState(() {
        _imageFileAr = File(pickedFile!.path);
      });
    } catch (e){
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // Categories de vêtement
    itemsCategories = widget.categories;

    /// EN MODE AJOUT
    if(widget.pageMode == 'A'){
      categorieValue = "1";
    }
    /// EN MODE MODIFICATION
    else {
      widget.productMap!['libelle'] != null ? designationCtrl.text = widget.productMap!['libelle'] : designationCtrl.text = '';
      widget.productMap!['prix_ht'] != null ? prixHtCtrl.text = widget.productMap!['prix_ht'].toString() : prixHtCtrl.text = '';
      categorieValue = widget.productMap!['categorie_vetement_id'].toString();

      setBaseModele();
      if(widget.productMap?['image_av'].toString() != '' || widget.productMap?['image_av'].toString() != null) {
        getImageFileFromNetwork(widget.productMap!['image_av'].toString());
      }

    }
    super.initState();
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
                /// GESTION DES IMAGES
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
                          /// IMAGE AVANT DU PRODUIT
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
                                        image: _imageFileAv == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFileAv!.path)),
                                        //image: _imageFileCompressed == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFileCompressed!.path)),
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
                                    takeFirstPicture(ImageSource.camera);
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
                                  onPressed: () async {
                                    takeFirstPicture(ImageSource.gallery);
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
                          /// IMAGE ARRIERE DU PRODUIT
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
                                        image: _imageFileAr == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFileAr!.path)),
                                        //image: _imageFileAvCompressed == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFileAvCompressed!.path)),
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
                                    takeSecondPicture(ImageSource.camera);
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
                                    takeSecondPicture(ImageSource.gallery);
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
                /// CHAMPS DE SAISIE
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
                          controller: designationCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Libellé',
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
                          controller: prixHtCtrl,
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Prix HT',
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
                        child: DropdownButton<String>(
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(8),
                          elevation: 15,
                          underline: SizedBox(),
                          hint: textMontserrat('Choisir une catégorie',16,Colors.grey,TextAlign.left),
                          value: categorieValue,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          items: itemsCategories.map((map) {
                            return DropdownMenuItem<String>(
                              value: map['id'].toString(),
                              child: textMontserrat(map['libelle'],16,Colors.black, TextAlign.left),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              categorieValue = newValue!;
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
                          borderRadius: BorderRadius.circular(8),
                          elevation: 15,
                          underline: SizedBox(),
                          hint: textMontserrat('Où enregistrer',16,Colors.grey,TextAlign.left),
                          value: baseModeleValue,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          items: itemsBaseModele.map((String itemsValue) {
                            return DropdownMenuItem(
                              value: itemsValue,
                              child: textMontserrat(itemsValue,16,Colors.black, TextAlign.left),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              baseModeleValue = newValue!;
                            });
                          },
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 25,),

                /// BOUTON DE VALIDATION
                GestureDetector(
                  onTap: () async {
                    
                    if(widget.pageMode == 'A'){ /// SI ON EST EN MODE AJOUT
                      // Faire des vérifications et la validation des champs
                      if(designationCtrl.text.isEmpty || prixHtCtrl.text.isEmpty || categorieValue!.isEmpty || baseModeleValue!.isEmpty) {
                        Fluttertoast.showToast(msg: 'Tous les champs sont obligatoires !');
                        return;
                      }

                      // Faire la compression de l'image Avant
                      if(_imageFileAv != null){
                        _imageFileAvCompressed = await compressImage(_imageFileAv!);
                        final sizeBefore = _imageFileAv!.lengthSync() / 1024;
                        print('Image size before $sizeBefore kb');
                        final sizeAfter = _imageFileAvCompressed!.lengthSync() / 1024;
                        print('Image size after $sizeAfter kb');
                      }

                      // Faire la compression de l'image Arriere
                      if(_imageFileAr != null){
                        _imageFileArCompressed = await compressImage(_imageFileAr!);
                        final sizeBefore = _imageFileAr!.lengthSync() / 1024;
                        print('Image size before $sizeBefore kb');
                        final sizeAfter = _imageFileArCompressed!.lengthSync() / 1024;
                        print('Image size after $sizeAfter kb');
                      }
                      createProduct(getCategorieVetementId()!, designationCtrl.text, prixHtCtrl.text, getBaseModele()!);

                    } else { /// SI ON EST EN MODE MODIFICATION
                      // Faire des vérifications et la validation des champs
                      if(designationCtrl.text.isEmpty || prixHtCtrl.text.isEmpty || categorieValue!.isEmpty || baseModeleValue!.isEmpty) {
                        Fluttertoast.showToast(msg: 'Tous les champs sont obligatoires !');
                        return;
                      }

                      // Faire la compression de l'image Avant
                      if(_imageFileAv != null){
                        _imageFileAvCompressed = await compressImage(_imageFileAv!);
                        final sizeBefore = _imageFileAv!.lengthSync() / 1024;
                        print('Image size before $sizeBefore kb');
                        final sizeAfter = _imageFileAvCompressed!.lengthSync() / 1024;
                        print('Image size after $sizeAfter kb');
                      }

                      // Faire la compression de l'image Arriere
                      if(_imageFileAr != null){
                        _imageFileArCompressed = await compressImage(_imageFileAr!);
                        final sizeBefore = _imageFileAr!.lengthSync() / 1024;
                        print('Image size before $sizeBefore kb');
                        final sizeAfter = _imageFileArCompressed!.lengthSync() / 1024;
                        print('Image size after $sizeAfter kb');
                      }
                      updateProduct(getCategorieVetementId()!, designationCtrl.text, prixHtCtrl.text, getBaseModele()!);
                    }

                  },
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textMontserrat(
                          widget.pageMode == 'A' ? 'Valider' : 'Modifier', 18,
                          Colors.white, TextAlign.center,
                          fontWeight: FontWeight.w500,
                        ),
                        isLoading
                            ? const SizedBox(width: 10,)
                            : const SizedBox(),
                        isLoading ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.0),
                        ) : const SizedBox()
                      ],
                    )
                    ,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createProduct(String categorieVetement, String libelle, String prix_ht, String base_modele) async {

    Map<String, String> data = {
      "categorie_vetement": categorieVetement,
      "libelle":  libelle,
      "prix_ht": prix_ht,
      "image_av": "",
      "image_ar": "",
      "base_modele": base_modele,
    };

    String bearerToken = 'Bearer ${Globals.token!}';
    var headers = {
      'Accept':'application/json',
      'Content-Type':'application/json',
      'Authorization': bearerToken,
    };

    // create multipart request for POST
    final request = http.MultipartRequest('POST', Uri.parse(productRoot));

    // add image file to multipart request
    if(_imageFileAvCompressed != null){
      final image = await http.MultipartFile.fromPath('image_av', _imageFileAvCompressed!.path);
      request.files.add(image);
    }
    if(_imageFileArCompressed != null){
      final image = await http.MultipartFile.fromPath('image_ar', _imageFileArCompressed!.path);
      request.files.add(image);
    }

    // add data to multipart request
    request.fields.addAll(data);

    // add headers to multipart request
    request.headers.addAll(headers);

    // Show Loading Progress
    progressIndicator(true);

    // send multipart request and get response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    // Disable Loading Progress
    progressIndicator(false);

    // handle response
    if (response.statusCode == 201) {
      final responseData = jsonDecode(responseString);
      print(responseData);
      Fluttertoast.showToast(msg: 'Modèle enregistré avec succès !');
      Navigator.pop(context as BuildContext);
    } else {
      Fluttertoast.showToast(msg: '${response.statusCode} Erreur lors de l\'enregistrement !');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> updateProduct(String categorieVetement, String libelle, String prix_ht, String base_modele) async {

    Map<String, String> data = {
      "categorie_vetement": categorieVetement,
      "libelle":  libelle,
      "prix_ht": prix_ht,
      "image_av": "",
      "image_ar": "",
      "base_modele": base_modele,
      "_method" : "PUT"
    };

    String bearerToken = 'Bearer ${Globals.token!}';
    var headers = {
      'Accept':'application/json',
      'Content-Type':'application/json',
      'Authorization': bearerToken,
      //'X-HTTP-Method-Override': 'PUT'
    };

    // create multipart request for POST
    final request = http.MultipartRequest('POST', Uri.parse("$productRoot/${widget.productMap!['id'].toString()}"));

    // add image file to multipart request
    if(_imageFileAvCompressed != null){
      final image = await http.MultipartFile.fromPath('image_av', _imageFileAvCompressed!.path);
      request.files.add(image);
    }
    if(_imageFileArCompressed != null){
      final image = await http.MultipartFile.fromPath('image_ar', _imageFileArCompressed!.path);
      request.files.add(image);
    }

    // add data to multipart request
    request.fields.addAll(data);

    // add headers to multipart request
    request.headers.addAll(headers);

    // Show Loading Progress
    progressIndicator(true);

    // send multipart request and get response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    // Disable Loading Progress
    progressIndicator(false);

    // handle response
    if (response.statusCode == 201) {
      final responseData = jsonDecode(responseString);
      print(responseData);
      Fluttertoast.showToast(msg: 'Modification effectuée avec succès !');
      Navigator.pop(context as BuildContext);
    } else {
      Fluttertoast.showToast(msg: '${response.statusCode} Erreur lors de l\'enregistrement !');
      throw Exception('Failed to upload image');
    }
  }

  String? getBaseModele(){
    if(baseModeleValue == 'Confection'){
      return '1';
    } else if(baseModeleValue == 'Boutique'){
      return '2';
    } else if(baseModeleValue == 'Confection et boutique'){
      return '3';
    } else {
      return null;
    }
  }
  void setBaseModele(){
    setState(() {
      if(widget.productMap!['base_modele_id'].toString() == '1'){
        baseModeleValue = 'Confection';
      } else if (widget.productMap!['base_modele_id'].toString() == '2'){
        baseModeleValue = 'Boutique';
      } else if (widget.productMap!['base_modele_id'].toString() == '3'){
        baseModeleValue = 'Confection et boutique';
      }
    });
  }

  String? getCategorieVetementId(){
    for(int i = 0; i < itemsCategories.length; i++){
      if(itemsCategories[i]['id'].toString() == categorieValue.toString()){
        return itemsCategories[i]['id'].toString();
      }
    }
    return null;
  }

  // Retrieve image from Network
  Future<void> getImageFileFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final fileName = url.split('/').last;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(bytes);

   setState(() {
     _imageFileAv = file;
   });
   
  }

  void progressIndicator(bool value){
    if(value){
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  // Compress my Image
  Future<File> compressImage(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 25, // The quality of the compressed image, from 0 to 100.
      //targetWidth: 800, // The maximum width of the compressed image.
      //targetHeight: 800, // The maximum height of the compressed image.
    );
    return compressedFile;
  }

}
