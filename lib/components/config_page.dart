import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:procouture/components/message_box.dart';
import 'package:procouture/screens/settings/apropos_page.dart';
import 'package:procouture/screens/settings/liste_mesures_page.dart';
import 'package:procouture/screens/settings/mon_compte_page.dart';
import '../screens/confection/commande/livraison_page.dart';
import '../screens/settings/user_config_page.dart';
import '../widgets/custom_text.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String nomPolice = 'Raleway';

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20,),
          InkWell(
            onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_) => MonComptePage()));},
            child: ListTile(
              leading: Icon(Icons.store_mall_directory_rounded,color: Colors.green),
              title: Text('Mon compte', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
          ),
          Divider(),
          InkWell(
            onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_)=> UserConfigPage()));},
            child: ListTile(
              leading: Icon(Icons.group,color: Colors.blue),
              title: Text('Utilisateurs', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
          ),
          InkWell(
            onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ListeMesuresPage()));},
            child: ListTile(
              leading: Icon(Icons.list_alt_rounded,color: Colors.pink),
              title: Text('Liste de mesures', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.monetization_on_rounded,color: Colors.purple),
              title: Text('Abonnement', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
            //onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FamillePage()));},
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.support_agent_rounded,color: Colors.blueGrey),
              title: Text('Support', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
            //onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_) => NomsMesurePage()));},
          ),
          InkWell(
            onTap: (){ Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const Livraison()));},
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.bell,color: Colors.red),
              title: Text('Notifications de livraison', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
          ),
          Divider(),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.language_outlined,color: Colors.cyan),
              title: Text('Langues', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
              trailing: PopupMenuButton<int>(
                icon: Icon(Icons.keyboard_arrow_down),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                onSelected: (int value){
                  if (value == 2) {
                    Fluttertoast.showToast(msg: 'English version is not available for the time being!', toastLength: Toast.LENGTH_LONG);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    // row has two child icon and text.
                    child: Row(
                      children: [
                        Image.asset('assets/images/french-flag.png',fit: BoxFit.contain, height: 40, width: 40,),
                        const SizedBox(width: 10,),
                        textOpenSans("Français",16,Colors.black,TextAlign.left)
                      ],
                    ),
                  ),
                  // popupmenu item 2
                  PopupMenuItem(
                    value: 2,
                    // row has two child icon and text
                    child: Row(
                      children: [
                        Image.asset('assets/images/english-flag.png',fit: BoxFit.contain, height: 40, width: 40,),
                        const SizedBox(width: 10,),
                        textOpenSans("English",16,Colors.black,TextAlign.left)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_) => AProposPage()));},
            child: ListTile(
              leading: Icon(Icons.help,color: Colors.brown),
              title: Text('A propos', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
          ),
          InkWell(
            onTap: (){msgBoxLogOut(context);},
            child: ListTile(
              leading: Icon(Icons.exit_to_app_outlined,color: Colors.redAccent),
              title: Text('Se déconnecter', style: TextStyle(fontSize: 17,fontFamily: nomPolice),),
            ),
          ),
        ],
      ),
    );
  }
}
