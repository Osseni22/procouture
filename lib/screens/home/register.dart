import 'package:flutter/material.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  int _currentStep = 0;
  late PageController _pageController;

  @override
  void initState() {
   //
    super.initState();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: myDefaultAppBar('Création de compte', context, bgColor: Colors.transparent),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg/fond_login_procouture2.png'),
                fit: BoxFit.cover
            )
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // AppBar
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: () {Navigator.pop(context);},
                          icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,)
                      ),
                      textMontserrat('Création de compte', 20, Colors.black, TextAlign.center, fontWeight: FontWeight.w600),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.close,color: Colors.white.withOpacity(0.0),)
                      ),
                    ]
                ),
              ),
              // Title
              SizedBox(height: 20,),
              // Step indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 25,
                    child: textMontserrat('1', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 4, width: 30, color: Colors.black,),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 25,
                    child: textMontserrat('2', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 4, width: 30, color: Colors.black,),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 25,
                    child: textMontserrat('3', 18, Colors.black, TextAlign.center, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              textMontserrat('Informations utilisateur', 19, Colors.black, TextAlign.center, fontWeight: FontWeight.w400),
              SizedBox(height: 20,),

              // PageView
              Expanded(
                  child: PageView()
              ),
              // Buttons
              Container(
                height: 50,
                alignment: Alignment.center,
                //color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Previous
                      Container(
                        height: double.infinity,
                        width: 125,
                        child: Visibility(
                          visible: true,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                if(_currentStep > 1){
                                  _currentStep++;
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                color: kProcouture_green,
                              ),
                              child: textOpenSans('<< Précédent', 15, Colors.white, TextAlign.center),
                            ),
                          ),
                        ),
                      ),

                      /// Next
                      Container(
                        height: double.infinity,
                        width: 125,
                        child: Visibility(
                          visible: true,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                if(_currentStep <= 3){
                                  _currentStep--;
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                color: kProcouture_green,
                              ),
                              child: textOpenSans('Suivant >>', 15, Colors.white, TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        )
      ),
    );
  }

  Future<void> registerInfos() async {

  }
}
