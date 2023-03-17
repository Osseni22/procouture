import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';

import '../../widgets/default_app_bar.dart';

class AProposPage extends StatelessWidget {
  const AProposPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('A Propos', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Image(image: AssetImage('assets/images/appstore.png'),height: 150, width: 150,),
              SizedBox(height: 20,),
              textRaleway('Expiration de la licence le : 31/12/2023', 16, Colors.black, TextAlign.center),
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  //height: 400,
                  child: ListView(
                    children: [
                      InkWell(
                        onTap: (){/*Navigator.of(context).push(MaterialPageRoute(builder: (_) => AProposPage()));*/},
                        child: ListTile(
                          leading: Icon(Icons.help,color: Colors.grey, size: 35,),
                          title: textLato('Version de l\'application', 17, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway('1.0.0', 16, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: (){/*Navigator.of(context).push(MaterialPageRoute(builder: (_) => AProposPage()));*/},
                        child: ListTile(
                          leading: Icon(Icons.star,color: Colors.grey, size: 35,),
                          title: textLato("Noter l'application", 17, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway("Dites ce que vous pensez de l'application", 14, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: (){/*Navigator.of(context).push(MaterialPageRoute(builder: (_) => AProposPage()));*/},
                        child: ListTile(
                          leading: Icon(Icons.info,color: Colors.grey, size: 35,),
                          title: textLato('ProCouture Mobile', 17, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway('En savoir plus sur l\'application', 14, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: (){/*Navigator.of(context).push(MaterialPageRoute(builder: (_) => AProposPage()));*/},
                        child: ListTile(
                          leading: Icon(Icons.lock_open_outlined,color: Colors.grey, size: 35,),
                          title: textLato('Activer ProCouture', 17, Colors.black, TextAlign.start,fontWeight:FontWeight.w600),
                          subtitle: textRaleway('Quitter la version d\'essai et activer l\'application', 14, Colors.black, TextAlign.start),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

