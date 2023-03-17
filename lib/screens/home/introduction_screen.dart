import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:procouture/screens/home/login.dart';
import 'package:procouture/utils/constants/color_constants.dart';

class AppIntroduction extends StatefulWidget {
  const AppIntroduction({Key? key}) : super(key: key);

  @override
  State<AppIntroduction> createState() => _AppIntroductionState();
}

class _AppIntroductionState extends State<AppIntroduction> {

  void _onIntroEnd(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
  }
  static const List<String> langues = <String>[
    'Français',
    'English',
  ];
  var langueValue = 'Français';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: kProcouture_green,
      /*appBar: AppBar(
        backgroundColor: Colors.transparent
      ),*/
      body: Padding(
        padding: EdgeInsets.only(top: 40),
        child: IntroductionScreen(
          next: Text('Suiv. >>'),
          showSkipButton: false,
          onDone: () => _onIntroEnd(context),
          done: Text(''),
          dotsFlex: 3,
          pages: [
            PageViewModel(
              title: 'ProCouture Mobile',
              body: "Vous avez le Pouvoir de gérer votre entreprise de couture de façon globale",
              image: Image.asset('assets/images/sewing-pattern-5067653_1920.png')
            ),
            PageViewModel(
                title: 'Prenez vos outils de travail',
                body: "Laissez ProCouture se charger du reste",
                image: Image.asset('assets/images/sewing-machine.png')
            ),
            PageViewModel(
              title: 'Inscrivez-vous',
                bodyWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Et profitez des nombreuses fonctionnalités',style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
                    SizedBox(height: 50,),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        underline: SizedBox(),

                        // Initial Value
                        value: langueValue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: langues.map((String items) {
                          return DropdownMenuItem(
                            alignment: Alignment.center,
                            value: items,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (items == 'English')?
                                Image.asset('assets/images/english-flag.png',fit: BoxFit.contain, height: 40, width: 30,)
                                  : Image.asset('assets/images/french-flag.png',fit: BoxFit.contain, height: 30, width: 30,),
                                const SizedBox(width: 10,),
                                Text(items, textAlign: TextAlign.center,style: TextStyle(fontSize: 18,),),
                              ],
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            langueValue = newValue!;
                          });
                          if(newValue == 'English'){
                            Fluttertoast.showToast(msg: 'English version is not available for the time being!', toastLength: Toast.LENGTH_LONG);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: kProcouture_green,foregroundColor: Colors.white
                        ),
                        onPressed: () => _onIntroEnd(context),
                        child: Text('Commencer',style: TextStyle(fontSize: 18),)
                      ),
                    ),
                  ],
                ),
                image: Image.asset('assets/images/presentation_image3_compressed.png')
            ),
          ],
        ),
      ),
    );

  }
}
