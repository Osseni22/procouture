import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:procouture/screens/admin/admin_atelier_page.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/widgets/custom_field_container.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../components/message_box.dart';
import '../../models/Atelier.dart';
import '../../services/api_routes/routes.dart';
import '../../utils/constants/color_constants.dart';

class Register2 extends StatefulWidget {
  const Register2({Key? key}) : super(key: key);

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late PageController pageController;
  bool isLoading = false;
  bool isVisible = false;
  bool isSubmitted = false;

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

  List<Monnaie> allMonnaies = [];
  Monnaie? selectedMonnaie;
  List<Pays> allPays = [];
  Pays? selectedPays;

  final _key = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureText2 = true;
  double textFieldHeight = 60;

  int currentPage = 1;

  // First Page Fields
  TextEditingController ctrlPrenom = TextEditingController();
  TextEditingController ctrlNom = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlTelephone = TextEditingController();
  TextEditingController ctrlAdresse = TextEditingController();
  TextEditingController ctrlMotDePasse = TextEditingController();

  // Second Page Fields
  TextEditingController ctrlNomAtelier = TextEditingController();
  TextEditingController ctrlEmailAtelier = TextEditingController();
  TextEditingController ctrlTelephoneMobile = TextEditingController();
  TextEditingController ctrlTelephoneFix = TextEditingController();
  TextEditingController ctrlMotDePasseAtelier = TextEditingController();

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    registerInfos();
    /*selectedPays = allPays[57];
    selectedMonnaie = allMonnaies[2];*/
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
      key: scaffoldKey,
      //backgroundColor: Colors.grey[100],
      //appBar: myDefaultAppBar('Inscription', context),
      body: isLoading? Center(child: CircularProgressIndicator()) : Stack(
        children: [
          /// Top zone
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff31A05E), Color(0xff4CF590)]
              )
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35,),
                  IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
                  SizedBox(height: 10,),
                  textMontserrat('   ProCouture', 24, Colors.white, TextAlign.start, fontWeight: FontWeight.w600),
                  SizedBox(height: 10,),
                  textRaleway('     Création de compte', 15, Colors.white, TextAlign.start),
                ],
              ),
            ),
          ),
          /// Bottom zone
          Container(
            margin: EdgeInsets.only(top: 190),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            child: Column(
              children: [
                /// Step indicator
                Container(
                  padding: EdgeInsets.only(left: 25),
                  alignment: Alignment.centerLeft,
                  //color: Colors.blue,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textMontserrat('Etape $currentPage / 3', 16, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
                      // Step Title
                      textMontserrat(stepTitle(), 14, Colors.black, TextAlign.start)
                    ],
                  ),
                ),
                /// PageView
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    //scrollDirection: Axis.,
                    children: [
                      buildStep1(),
                      buildStep2(),
                      buildStep3(),
                    ],
                  )
                ),
                /// Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap:(){
                          if(currentPage > 1){
                            previousStep();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: Colors.white,
                          ),
                          child: textOpenSans('<< Précédente', 15, currentPage != 1 ? kProcouture_green : Colors.white, TextAlign.center, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: (){
                          if(currentPage < 3){
                            nextStep();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: Colors.white,
                          ),
                          child: textOpenSans('Suivante >>', 15, currentPage != 3 ? kProcouture_green : Colors.white, TextAlign.center, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 5,),
              ],
            ),
          ),
          /// Decoration Image
          Positioned(
            top: 40,
            right: 20,
            child: Image.asset("assets/images/sewing-pattern-5067653_1920.png", width: 90,)
          ),
        ],
      ),
    );
  }

  String stepTitle(){
    if(currentPage == 1){
      return 'Informations Administrateur';
    }
    if(currentPage == 2){
      return 'Informations sur l\'atelier';
    }
    if(currentPage == 3){
      return 'Logo de l\'entreprise';
    }
    return 'Informations Administrateur';
  }
  void previousStep(){
    setState(() {
      currentPage--;
      pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
    });
  }
  void nextStep(){
    setState(() {
      if (currentPage == 1) {
        if(!InfoAdminOK()){
          Fluttertoast.showToast(msg: 'Veuillez renseigner tous les champs obligatoires 1/3');
          return;
        }
      }
      if (currentPage == 2) {
        if(!InfoAtelierOK()){
          Fluttertoast.showToast(msg: 'Veuillez renseigner tous les champs obligatoires 2/3');
          return;
        }
      }
      currentPage++;
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  Widget buildStep1(){
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Container(
            height: 400,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [kDefaultBoxShadow3]
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
                      Expanded(
                        child: TextField(
                          controller: ctrlNom,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Nom',
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
                          controller: ctrlPrenom,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person_outline),
                              hintText: 'Prenom',
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
                          controller: ctrlEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(CupertinoIcons.mail_solid),
                              hintText: 'E-mail',
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
                          controller: ctrlTelephone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Telephone',
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
                          controller: ctrlAdresse,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.location_city_rounded),
                              hintText: 'Adresse',
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
                    //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ctrlMotDePasse,
                          keyboardType: TextInputType.text,
                          obscureText: isVisible,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Mot de passe',
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){ setState(() {
                        isVisible = !isVisible;
                      });}, icon: Icon(isVisible? Icons.visibility : Icons.visibility_off)),
                      textOpenSans('*', 22, Colors.red, TextAlign.center)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildStep2(){
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Container(
            height: 400,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [kDefaultBoxShadow3]
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
                          onChanged: (Pays? value) {
                            setState(() {
                              selectedPays = value!;
                            });
                          },
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
                          onChanged: (Monnaie? value) {
                            setState(() {
                              selectedMonnaie = value!;
                            });
                          },
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
                /*Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Mot de passe',
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat', color: Colors.grey)
                          ),
                        ),
                      ),
                      textOpenSans('*', 22, Colors.red, TextAlign.center)
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildStep3(){
    return Center(
      child: Column(
        children: [
          Container(
            height: 300,
            //color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: imageFile == null ? AssetImage('assets/images/appstore.png') as ImageProvider : FileImage(File(imageFile!.path)),
                      fit: BoxFit.contain
                    )
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    takeFirstPicture(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100
                  ),
                  child: textMontserrat('Choisir le logo', 14, Colors.black, TextAlign.center),
                )
              ],
            ),
          ),
          //SizedBox(height: 10,),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () async {
              createAcompte();
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kDefaultBoxShadow],
                borderRadius: BorderRadius.circular(35),
                  /*gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xff31A05E), Colors.green.shade300*//*Color(0xff2ECB6D)*//*]
                  )*/
              ),
              child: textMontserrat('Je cree mon compte', 16, kProcouture_green, TextAlign.center, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
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
      selectedPays = allPays[57];
      for(int i = 0; i < responseBody['data']['monnaies'].length; i++) { // Get all commandes
        monnaie = Monnaie.fromJson(responseBody['data']['monnaies'][i]);
        allMonnaies.add(monnaie);
      }
      selectedMonnaie = allMonnaies[2];
    }
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
    ctrlPrenom.dispose();
    ctrlNom.dispose();
    ctrlEmail.dispose();
    ctrlTelephone.dispose();
    ctrlAdresse.dispose();
    ctrlMotDePasse.dispose();

    ctrlNomAtelier.dispose();
    ctrlEmailAtelier.dispose();
    ctrlTelephoneMobile.dispose();
    ctrlTelephoneFix.dispose();
    ctrlMotDePasseAtelier.dispose();
  }
  bool InfoAdminOK(){
    bool isOK = true;
    if(ctrlPrenom.text.isEmpty){
      isOK = false;
    }
    if(ctrlNom.text.isEmpty){
      isOK = false;
    }
    if(ctrlTelephone.text.isEmpty){
      isOK = false;
    }
    if(!EmailValidator.validate(ctrlEmail.text)){
      Fluttertoast.showToast(msg: 'Email invalide !');
      isOK = false;
    }
    if(ctrlEmail.text.isEmpty){
      isOK = false;
    }
    if(ctrlMotDePasse.text.isEmpty){
      isOK = false;
    }
    if(ctrlMotDePasse.text.length < 6){
      Fluttertoast.showToast(msg: '6 caractères au minimum pour le mot de passe');
      isOK = false;
    }
    return isOK;
  }
  bool InfoAtelierOK(){
    bool isOK = true;
    if(ctrlNomAtelier.text.isEmpty){
      isOK = false;
    }
    /*if(ctrlEmailAtelier.text.isEmpty){
      isOK = false;
    }*/
    if(ctrlTelephoneMobile.text.isEmpty){
      isOK = false;
    }
    /*if(ctrlTelephoneFix.text.isEmpty){
      isOK = false;
    }*/
    return isOK;
  }

  Future<void> createAcompte() async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse(r_register));
    request.fields.addAll({
      'prenom': ctrlPrenom.text,
      'nom': ctrlNom.text,
      'email': ctrlEmail.text,
      'password': ctrlMotDePasse.text,
      'telephone': ctrlTelephone.text,
      'adresse': ctrlAdresse.text,
      'atelier_libelle': ctrlNomAtelier.text,
      'atelier_tel_mobile': ctrlTelephoneMobile.text,
      'atelier_tel_fixe': ctrlTelephoneFix.text,
      'atelier_email': ctrlEmailAtelier.text,
      'atelier_monnaie': selectedMonnaie!.id.toString(),
      'atelier_pays': selectedPays!.id.toString(),
    });

    request.headers.addAll(headers);

    if(imageFile != null){
      final image = await http.MultipartFile.fromPath('atelier_logo', imageFile!.path);
      request.files.add(image);
    }
    loadingProgress(true);
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    loadingProgress(false);

    if (response.statusCode == 201) {
      Globals.isOK = true;
      final responseData = jsonDecode(responseString);
      Fluttertoast.showToast(msg: responseData['messages']);
      Navigator.pop(scaffoldKey.currentState!.context);
    } else {
      final responseData = jsonDecode(responseString);
      Fluttertoast.showToast(msg: responseData['messages']);
    }

  }

}
