import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/screens/admin/admin_atelier_page.dart';
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/components/login_page_components.dart';
import 'package:procouture/screens/home/register.dart';
import 'package:procouture/screens/home/register2.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/services/api_routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:procouture/screens/home/confidential.dart';

import '../../components/message_box.dart';
import '../../utils/constants/color_constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailUsernameCtrl = TextEditingController();
  TextEditingController passWordCtrl = TextEditingController();

  bool isChecked = false;
  bool isConnecting = false;
  bool isAdmin = false;
  bool isPassword = true;
  bool rememberMe = false;

  String? emailUsername;
  String? password;
  bool? iamAdmin;
  bool isSaved = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
      setState(() {});
    });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    _controller.forward();

    /// Get the last entered user informations
    getUserInfo();

    super.initState();

    // Show the modal bottom sheet when the page is opening
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      //if (isSaved){
        _showModalBottomSheet();
      //}
    });*/
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor : Colors.grey[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg/fond_login_procouture2.png'),
                      fit: BoxFit.cover
                  )
              ),
              child: Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _transform.value,
                  child: Container(
                    width: size.width * .9,
                    height: size.width * 1.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 90,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/appstore.png'),
                              )
                          ),
                        ),
                        SizedBox(),
                        component1(emailUsernameCtrl,isAdmin? Icons.mail_rounded: Icons.person, isAdmin? 'E-mail':"Nom d'utilisateur", false,false),
                        component1(passWordCtrl,Icons.lock_outline, 'Mot de passe', true,true),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*component2(
                              'Se Connecter', 2.6, () {
                              HapticFeedback.mediumImpact();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AtelierPage()));
                            },
                            ),*/
                            GestureDetector(
                              onTap: () async {
                                if(emailUsernameCtrl.text.isEmpty || passWordCtrl.text.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: textLato('Veuillez renseigner les deux champs !', 12, Colors.white, TextAlign.start),
                                        elevation: 3.0,
                                      )
                                  );
                                  return;
                                }
                                //saveUserInfo();
                                if(isAdmin){
                                  loginAdmin(emailUsernameCtrl.text.toString(), passWordCtrl.text.toString(), 'mobile', CnxInfo.deviceName!);
                                } else {
                                  login(emailUsernameCtrl.text.toString(), passWordCtrl.text.toString(), 'mobile', CnxInfo.deviceName!);
                                }

                              },
                              child: Container(
                                height: size.width / 8,
                                width: size.width / 2.6,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: kProcouture_green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    textOpenSans('Se connecter', 14, Colors.white, TextAlign.start),
                                    isConnecting? const SizedBox(width: 10,) : const SizedBox(),
                                    isConnecting? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                                    ): const SizedBox()
                                  ],
                                ),
                                //child: textOpenSans('Se connecter', 14, Colors.white, TextAlign.start)
                              ),
                            ), /*:
                            Container(
                                height: size.width / 8,
                                width: size.width / 2.6,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator()
                            ),*/
                            SizedBox(width: size.width / 25),
                            Container(
                              width: size.width / 2.6,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.withOpacity(0.3),)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: isAdmin,
                                    activeColor: Colors.white,
                                    checkColor: kProcouture_green,
                                    onChanged: (bool? value){
                                      setState(() {
                                        isAdmin = value!;
                                      });

                                    },
                                  ),
                                  textOpenSans('Administrateur',13,Colors.black,TextAlign.left),
                                ],
                              ),
                            )
                          ],
                        ),
                        //const SizedBox(),
                        Container(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: Colors.white,
                                checkColor: kProcouture_green,
                                onChanged: (bool? value){
                                  setState(() {
                                    rememberMe = value!;
                                  });

                                },
                              ),
                              textOpenSans('Se souvenir de moi',13,Colors.black,TextAlign.left),
                            ],
                          ),
                        ),
                        Container(height: 30,
                          child: Column(
                            children: [
                              Text('En utilisant l\'application vous acceptez la', style: TextStyle(fontSize: 12,fontFamily: 'Raleway')),
                              RichText(
                                text: TextSpan(
                                  text: 'la politique de confidentialité',
                                  style: TextStyle(color: Colors.green, fontSize: 12,fontFamily: 'Raleway'),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => const Confidentials()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //_showModalBottomSheet();
                            Globals.isOK = false;
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => const Register2()));

                            if(Globals.isOK){
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => bottomSheet(),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(17.0),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: size.width / 1.22,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: textOpenSans('Créer un compte',16,kProcouture_green.withOpacity(0.8),TextAlign.center,fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget component1(TextEditingController myController, IconData icon, String hintText,bool isPwField ,bool visibleString/* bool isEmail*/) {
    Size size = MediaQuery.of(context).size;
    bool isPw = isPassword;
    return Container(
      height: 50,
      width: size.width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 70),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: myController,
        style: TextStyle(color: Colors.black.withOpacity(.8), fontFamily: 'OpenSans'),
        obscureText: isPwField? isPassword : false,
        keyboardType: isAdmin ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black.withOpacity(.7),
          ),
          suffixIcon: visibleString ? IconButton(
            onPressed: (){
              setState(() { isPassword = !isPassword; });
            },
            icon: isPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          ) : null,
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle:
          TextStyle(fontSize: 15, color: Colors.black.withOpacity(.5), fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Container(
        height: size.width / 8,
        width: size.width / width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kProcouture_green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          string,
          style: const TextStyle(color: Colors.white, /*fontWeight: FontWeight.w600*/fontFamily: 'Raleway'),
        ),
      ),
    );
  }

  void startLoading(){
    setState(() {
      isConnecting = true;
    });
  }
  void endLoading(){
    setState(() {
      isConnecting = false;
    });
  }

  Future<void> login (String username, String password, String role, String deviceName) async {
    Map data = {
      'username': username,
      'password': password,
      'role': role,
      'device_name': deviceName
    };
    //print(data.toString());
    startLoading();
    final response = await http.post(
        Uri.parse(r_login),
        body: data,
        encoding: Encoding.getByName("utf-8")
    );
    endLoading();

    // Create a JSON decoder object
    final jsonDecoder = JsonDecoder();
    // Decode the JSON data into a Map<String, dynamic> object
    final jsonMap = jsonDecoder.convert(response.body);
    print(jsonMap);

    if (response.statusCode == 200){

      // Extract data from the nested JSON object
      CnxInfo.userID = jsonMap['user']['id'];
      CnxInfo.userEmail = jsonMap['user']['email'];
      CnxInfo.userFirstName = jsonMap['user']['prenom'];
      CnxInfo.userLastName = jsonMap['user']['nom'];
      CnxInfo.atelierID = jsonMap['user']['atelier_id'];
      CnxInfo.token = jsonMap['token'];
      CnxInfo.symboleMonnaie = jsonMap['user']['atelier']['monnaie']['symbole'];
      CnxInfo.atelierLibelle = jsonMap['user']['atelier']['libelle'];

      print(CnxInfo.symboleMonnaie);
      print(CnxInfo.atelierLibelle);
      print(CnxInfo.token);

      if(rememberMe){
        saveUserInfo(true);
      } else {
        saveUserInfo(false);
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (response.statusCode == 422){
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
      //Fluttertoast.showToast(msg: '${jsonMap['errors']['username']}');
    } else {
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
      //Fluttertoast.showToast(msg: '${jsonMap['errors']['username']}');
    }
  }

  Future<void> loginAdmin(String email, String password, String role, String deviceName) async {
    Map data = {
      'email': email,
      'password': password,
      'role': role,
      'device_name': deviceName
    };
    startLoading();
    final response = await http.post(
        Uri.parse(AdminRoutes.r_adminLogin),
        body: data,
        encoding: Encoding.getByName("utf-8")
    );
    endLoading();

    // Create a JSON decoder object
    final jsonDecoder = JsonDecoder();

    // Decode the JSON data into a Map<String, dynamic> object
    final jsonMap = jsonDecoder.convert(response.body);

    //print(jsonMap);

    if (response.statusCode == 200){

      // Extract data from the nested JSON object
      CnxInfo.userID = jsonMap['user']['id'];
      CnxInfo.userEmail = jsonMap['user']['email'];
      CnxInfo.userFirstName = jsonMap['user']['prenom'];
      CnxInfo.userLastName = jsonMap['user']['nom'];
      CnxInfo.atelierID = jsonMap['user']['atelier_id'];
      CnxInfo.token = jsonMap['token'];


      print(CnxInfo.token);

      if(rememberMe){
        saveUserInfo(true);
      } else {
        saveUserInfo(false);
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AtelierPage(token: CnxInfo.token!)));

    } else if (response.statusCode == 422){
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
    } else {
      if(jsonMap['messages'] != null){
        Fluttertoast.showToast(msg: '${jsonMap['messages']}');
      } else {
        Fluttertoast.showToast(msg: '${jsonMap['message']}');
      }
    }
  }

  // Last userInfo
  void getUserInfo() async {
    // get an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get the login information using the keys that you used to save them
    iamAdmin = prefs.getBool('isAdmin');
    emailUsername = prefs.getString('email');
    password = prefs.getString('password');
    if (prefs.getBool("isSaved") != null) {
      isSaved = prefs.getBool("isSaved")!;
    }
    setState(() {

    });

    print('iamAdmin : $iamAdmin');
    print('emailUsername : $emailUsername');
    print('password : $password');
    print('isSaved : $isSaved');

    // Put informations in their respective TextField
   /* if(emailUsername != null){
      emailUsernameCtrl.text = emailUsername!;
    }
    if(password != null){
      passWordCtrl.text = password!;
    }*/
  }
  void getAdminInfo() async {
    // get an instance of SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get the login information using the keys that you used to save them
    bool? value = prefs.getBool('isAdmin');
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    // Put informations in their respective TextField
    if(value != null && value == true){
      isAdmin = value;
    }
    if(email != null){
      emailUsernameCtrl.text = email;
    }
    if(password != null){
      passWordCtrl.text = password;
    }
  }

  // Save user info
  void saveUserInfo(bool saveInfo) async {
    if(emailUsernameCtrl.text.isNotEmpty && passWordCtrl.text.isNotEmpty){
      // get an instance of SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // save the login information using the SharedPreferences instance

      if(saveInfo){
        await prefs.setBool('isSaved', true);
        await prefs.setBool('isAdmin', isAdmin);
        await prefs.setString('email', emailUsernameCtrl.text);
        await prefs.setString('password', passWordCtrl.text);

      }
      else {
        await prefs.setBool('isSaved', false);
        await prefs.setBool('isAdmin', false);
        await prefs.setString('email', '');
        await prefs.setString('password', '');
      }
    }
  }

  /*void saveAdminInfo() async {
    if(emailUsernameCtrl.text.isNotEmpty && passWordCtrl.text.isNotEmpty){
      // get an instance of SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // save the login information using the SharedPreferences instance
      await prefs.setBool('isAdmin', isAdmin);
      await prefs.setString('email', emailUsernameCtrl.text);
      await prefs.setString('password', passWordCtrl.text);
    }
  }*/

  void _showModalBottomSheet() async {
    //await Future.delayed(Duration(seconds: 1));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return lastCnxBottomSheet();
      },
    );
  }


  Container bottomSheet(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 30,
            child: textMontserrat('Votre compte a été créé', 17, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
          ),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                child: textMontserrat("Veuillez confirmer l'Email que nous venons de vous envoyer, ensuite veuillez vous connecter en tant qu'Administrateur du compte pour la configuration.", 14, Colors.black, TextAlign.center),
              )
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(scaffoldKey.currentState!.context);
            },
            child: Container(
              height: 45,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: kProcouture_green
              ),
              child: textMontserrat("OK j'ai compris", 15, Colors.white, TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  Container lastCnxBottomSheet(){
    return Container(
      color: Colors.green.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          /*Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){ Navigator.pop(context);},
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.close, color: Colors.black,),
                ),
              ),
            ],
          ),*/
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(CupertinoIcons.person_fill, color: Colors.black45,size: 40,),
                  ),
                  SizedBox(height: 10,),
                  textMontserrat(emailUsername != null ? emailUsername! : '', 17, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
                  SizedBox(height: 50,),
                  GestureDetector(
                    onTap: (){
                      if(isSaved){
                        if(iamAdmin!){
                          loginAdmin(emailUsername!, password!, 'mobile', CnxInfo.deviceName!);
                        } else {
                          login(emailUsername!, password!, 'mobile', CnxInfo.deviceName!);
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: kProcouture_green
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          textMontserrat('Se connecter', 14, Colors.white, TextAlign.start),
                          isConnecting? const SizedBox(width: 10,) : const SizedBox(),
                          isConnecting? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                          ): const SizedBox()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){ Navigator.pop(context); },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.transparent,
                        border: Border.all(color: Colors.black)
                      ),
                      child: textMontserrat("Se connecter à un autre compte", 14, Colors.black, TextAlign.start),
                    ),
                  ),
                  SizedBox(height: 100,)
                ],
              ),
            )
          )
        ],
      ),
    );
  }

}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection,
      ) {
    return child;
  }
}

/* startLoading();
    await Future.delayed(Duration(seconds: 1));
    endLoading();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));

    msgBoxOk('Création de Compte', 'Veuillez confirmer l\'email que nous venons de vous envoyer, et vous connecter en tant que d\'Admin', context))

 */
