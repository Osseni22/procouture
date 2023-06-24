import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'dart:io';

import '../../models/Atelier.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/globals/global_var.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/default_box_shadow.dart';


class AdminAtelierSavePage extends StatefulWidget {
  final String pageMode; final Atelier? atelier;
  const AdminAtelierSavePage({Key? key, required this.pageMode, this.atelier}) : super(key: key);

  @override
  State<AdminAtelierSavePage> createState() => _AdminAtelierSavePageState();
}

class _AdminAtelierSavePageState extends State<AdminAtelierSavePage> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool isLoading = false;

  List<Monnaie> allMonnaies = [];
  Monnaie? selectedMonnaie;
  List<Pays> allPays = [];
  Pays? selectedPays;

  double textFieldHeight = 60;

  File? imageFile;
  final picker = ImagePicker();

  Future<void> takeFirstPicture(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      setState(() {
        imageFile = File(pickedFile!.path);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  TextEditingController ctrlNomAtelier = TextEditingController();
  TextEditingController ctrlEmailAtelier = TextEditingController();
  TextEditingController ctrlTelephoneMobile = TextEditingController();
  TextEditingController ctrlTelephoneFix = TextEditingController();
  TextEditingController ctrlMotDePasseAtelier = TextEditingController();

  @override
  void initState() {
    registerInfos();
    if(widget.pageMode != "A"){
      widget.atelier!.libelle != null ? ctrlNomAtelier.text = widget.atelier!.libelle! : ctrlNomAtelier.text = '';
      widget.atelier!.email != null ? ctrlEmailAtelier.text = widget.atelier!.email! : ctrlEmailAtelier.text = '';
      widget.atelier!.tel_mobile != null ? ctrlTelephoneMobile.text = widget.atelier!.tel_mobile! : ctrlTelephoneMobile.text = '';
      widget.atelier!.tel_fixe != null ? ctrlTelephoneFix.text = widget.atelier!.tel_fixe! : ctrlTelephoneFix.text = '';
      if(widget.atelier!.logo != null){
        getImageFileFromNetwork(widget.atelier!.logo.toString());
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Fiche atelier', context),
      body: isLoading? Center(child: CircularProgressIndicator()) : Center(
        child: SingleChildScrollView(
          //physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      takeFirstPicture(ImageSource.camera);
                    }, icon: Icon(Icons.camera_alt, color: Colors.grey, size: 33,)),
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.grey.shade200),
                          image: DecorationImage(
                            image: imageFile == null ? AssetImage('assets/images/No_image.png') as ImageProvider : FileImage(File(imageFile!.path)),
                            fit: BoxFit.cover
                          )
                      ),
                    ),
                    IconButton(onPressed: (){
                      takeFirstPicture(ImageSource.gallery);
                    }, icon: Icon(Icons.image_rounded, color: Colors.grey, size: 33,))
                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  height: 400,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [kDefaultBoxShadow]
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20,),
                            Expanded(
                              child: DropdownButton<Pays>(
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(8),
                                elevation: 8,
                                underline: SizedBox(),
                                hint: textMontserrat('Choisir un pays',16,Colors.grey,TextAlign.left),
                                value: selectedPays,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: allPays.map((Pays pays) {
                                  return DropdownMenuItem<Pays>(
                                    value: pays,
                                    child: textMontserrat(pays.libelle!,16,Colors.black, TextAlign.left),
                                  );
                                }).toList(),
                                onChanged: widget.pageMode == "A" ? (Pays? value) {
                                  setState(() {
                                    selectedPays = value!;
                                  });
                                } : null,
                              ),
                            ),
                            textOpenSans('*', 22, Colors.red, TextAlign.center)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 20,),
                            Expanded(
                              child: DropdownButton<Monnaie>(
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(8),
                                elevation: 8,
                                underline: SizedBox(),
                                hint: textMontserrat('Choisir une monnaie',16,Colors.grey,TextAlign.left),
                                value: selectedMonnaie,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                items: allMonnaies.map((Monnaie monnaie) {
                                  return DropdownMenuItem<Monnaie>(
                                    value: monnaie,
                                    child: textMontserrat(monnaie.libelle!,16,Colors.black, TextAlign.left),
                                  );
                                }).toList(),
                                onChanged: widget.pageMode == "A" ? (Monnaie? value) {
                                  setState(() {
                                    selectedMonnaie = value!;
                                  });
                                } : null,
                              ),
                            ),
                            textOpenSans('*', 22, Colors.red, TextAlign.center)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrlNomAtelier,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.location_city_rounded),
                                    hintText: 'Nom de l\'atelier',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            textOpenSans('*', 22, Colors.red, TextAlign.center)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrlEmailAtelier,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.mail),
                                    hintText: 'E-mail de l\'atelier',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            //textOpenSans('*', 22, Colors.red, TextAlign.center)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                            border: Border(bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrlTelephoneMobile,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.phone_android_rounded),
                                    hintText: 'Telephone mobile de l\'atelier',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            textOpenSans('*', 22, Colors.red, TextAlign.center)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          // border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrlTelephoneFix,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(CupertinoIcons.phone_solid),
                                    hintText: 'Telephone fixe de l\'atelier',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            //textOpenSans('*', 22, Colors.red, TextAlign.center)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    if (widget.pageMode == "A")  {
                      if(InfoAtelierOK()) {
                        createAtelier();
                      } else {
                        Fluttertoast.showToast(msg: 'Renseigner tous les champs obligatoires');
                        return;
                      }
                      Navigator.pop(context);
                    } else {
                      if(InfoAtelierOK()){
                        updateAtelier();
                      }
                    }
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white,
                      boxShadow: [kDefaultBoxShadow]
                    ),
                    child: textMontserrat(widget.pageMode == "A" ? "Valider" : "Modifier", 18, kProcouture_green, TextAlign.center, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool InfoAtelierOK(){
    bool isOK = true;
    if(ctrlNomAtelier.text.isEmpty){
      isOK = false;
    }
    if(ctrlEmailAtelier.text.isNotEmpty){
      if(!EmailValidator.validate(ctrlEmailAtelier.text)){
        Fluttertoast.showToast(msg: "E-mail invalide !");
        isOK = false;
      }
    }
    if(ctrlTelephoneMobile.text.isEmpty){
      isOK = false;
    }
    /*if(ctrlTelephoneFix.text.isEmpty){
      isOK = false;
    }*/
    return isOK;
  }

  void loadingProgress(bool value) {
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

  void disposeAll() {
    ctrlNomAtelier.dispose();
    ctrlEmailAtelier.dispose();
    ctrlTelephoneMobile.dispose();
    ctrlTelephoneFix.dispose();
    ctrlMotDePasseAtelier.dispose();
  }

  Future<void> registerInfos() async {
    var myHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    loadingProgress(true);
    final response = await http.get(
      Uri.parse(r_registerInfos),
      headers: myHeaders,
    );
    loadingProgress(false);

    if(response.statusCode == 200) {

      final responseBody = jsonDecode(response.body);

      late Pays monPays;
      late Monnaie monnaie;

      for(int i = 0; i < responseBody['data']['pays'].length; i++) { // Get all commandes
        monPays = Pays.fromJson(responseBody['data']['pays'][i]);
        allPays.add(monPays);
      }
      if (widget.pageMode == "A") {
        selectedPays = allPays[57];
      } else {
        selectedPays = widget.atelier!.pays!;
      }
      for(int i = 0; i < responseBody['data']['monnaies'].length; i++) { // Get all commandes
        monnaie = Monnaie.fromJson(responseBody['data']['monnaies'][i]);
        allMonnaies.add(monnaie);
      }
      if (widget.pageMode == "A") {
        selectedMonnaie = allMonnaies[2];
      } else {
        selectedMonnaie = widget.atelier!.monnaie!;
      }

    }
  }

  Future<void> createAtelier() async {

    var request = http.MultipartRequest('POST', Uri.parse(AdminRoutes.r_adminAtelier));
    request.fields.addAll({
      'libelle': ctrlNomAtelier.text,
      'tel_mobile': ctrlTelephoneMobile.text,
      'tel_fixe': ctrlTelephoneFix.text,
      'email': ctrlEmailAtelier.text,
      'monnaie': selectedMonnaie!.id.toString(),
      'pays': selectedPays!.id.toString()
    });

    request.headers.addAll(Globals.apiHeaders);

    if(imageFile != null){
      final image = await http.MultipartFile.fromPath('logo', imageFile!.path);
      request.files.add(image);
    }
    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: responseData['messages']);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }
  }

  Future<void> updateAtelier() async {

    var request = http.Request('PUT', Uri.parse(AdminRoutes.r_adminAtelier));

    request.body = json.encode({
      "libelle": ctrlNomAtelier.text,
      "tel_mobile": ctrlTelephoneMobile.text,
      "tel_fixe": ctrlTelephoneFix.text,
      "email": ctrlEmailAtelier.text,
      //"monnaie": selectedMonnaie!.id!,
      //"pays": selectedPays!.id!
    });

    request.headers.addAll(Globals.apiHeaders);

    /*if(imageFile != null){
      final image = await http.MultipartFile.fromPath('logo', imageFile!.path);
      request.files.add(image);
    }*/

    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = jsonDecode(responseString);
    loadingProgress(false);

    if (response.statusCode == 201) {
      Fluttertoast.showToast(msg: responseData['messages']);
      Navigator.pop(scaffoldKey.currentState!.context);
    } else {
      Fluttertoast.showToast(msg: responseData['messages']);
    }

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
      imageFile = file;
    });
  }

}
