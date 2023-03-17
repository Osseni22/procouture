import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procouture/components/accueil_page.dart';
import 'package:procouture/screens/home/atelier_page.dart';
import 'package:procouture/screens/home/home.dart';
import 'package:procouture/components/login_page_components.dart';
import 'package:procouture/screens/home/register.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'package:procouture/services/api_routes/routes.dart';

import '../../components/test_drop_downsearch.dart';
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

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passWordCtrl = TextEditingController();

  bool isChecked = false;
  bool isConnecting = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

    super.initState();
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
                        component1(emailCtrl,Icons.mail_rounded, 'E-mail', false, false),
                        component1(passWordCtrl,Icons.lock_outline, 'Mot de passe', true, false),
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
                                if(emailCtrl.text.isEmpty || passWordCtrl.text.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: textLato('Veuillez renseigner les deux champs !', 12, Colors.white, TextAlign.start),
                                        elevation: 3.0,
                                      )
                                  );
                                  return;
                                }
                                login(emailCtrl.text.toString(), passWordCtrl.text.toString(), 'mobile', Globals.deviceName!);
                               /* startLoading();
                                await Future.delayed(Duration(seconds: 1));
                                endLoading();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                                */
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
                                    value: isChecked,
                                    activeColor: Colors.white,
                                    checkColor: kProcouture_green,
                                    onChanged: (bool? value){
                                      setState(() {
                                        isChecked = value!;
                                      });

                                    },
                                  ),
                                  textOpenSans('Rester connecté',13,Colors.black,TextAlign.left),
                                ],
                              ),
                            )
                          ],
                        ),
                        //const SizedBox(),
                        Container(height: 30,
                          child: Column(
                            children: [
                              Text('En utilisant l\'application vous acceptez la', style: TextStyle(fontSize: 12,fontFamily: 'Raleway')),
                              RichText(
                                text: TextSpan(
                                  text: 'la politique de confidentialité',
                                  style: TextStyle(color: Colors.green, fontSize: 12,fontFamily: 'Raleway'),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Fluttertoast.showToast(
                                      msg: 'En cours d\'édition',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const Register()));
                              //Navigator.push(context, MaterialPageRoute(builder: (_) => const TestDropDownSearch()));
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

  Widget component1(TextEditingController myController, IconData icon, String hintText, bool isPassword, bool isEmail) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      width: size.width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: myController,
        style: TextStyle(color: Colors.black.withOpacity(.8), fontFamily: 'OpenSans'),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black.withOpacity(.7),
          ),
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

  void login (String email, String password, String role, String deviceName) async {
    Map data = {
      'email': email,
      'password': password,
      'role': role,
      'device_name': deviceName
    };
    //print(data.toString());
    startLoading();
    final response = await http.post(
        Uri.parse(LoginRoot),
        body: data,
        encoding: Encoding.getByName("utf-8")
    );
    endLoading();
    //print(jsonDecode(response.body));
    print(response.statusCode);

    if (response.statusCode == 200){

      // Create a JSON decoder object
      final jsonDecoder = JsonDecoder();

      // Decode the JSON data into a Map<String, dynamic> object
      final jsonMap = jsonDecoder.convert(response.body);

      // Extract data from the nested JSON object
      Globals.userID = jsonMap['user']['id'];
      Globals.userEmail = jsonMap['user']['email'];
      Globals.userFirstName = jsonMap['user']['prenom'];
      Globals.userLastName = jsonMap['user']['nom'];
      Globals.atelierID = jsonMap['user']['atelier_id'];
      Globals.token = jsonMap['token'];

      print(Globals.userID);
      print(Globals.userEmail);
      print(Globals.userFirstName);
      print(Globals.userLastName);
      print(Globals.atelierID);
      print(Globals.token);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (response.statusCode == 422){
      Fluttertoast.showToast(msg: "email ou mot de passe incorrect !");
    } else {
      Fluttertoast.showToast(msg: "Connexion au serveur echouée !");
    }
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
