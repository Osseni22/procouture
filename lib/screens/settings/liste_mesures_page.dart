import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:procouture/screens/settings/liste_mesures_ordonnee.dart';
import 'package:procouture/screens/settings/nom_mesure_save_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';

import '../../components/message_box.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/default_app_bar.dart';

class ListeMesuresPage extends StatefulWidget {
  const ListeMesuresPage({Key? key}) : super(key: key);

  @override
  State<ListeMesuresPage> createState() => _ListeMesuresPageState();
}

class _ListeMesuresPageState extends State<ListeMesuresPage> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myDefaultAppBar('Noms de mesures',context,
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListeMesuresOrdonnees()));},
                icon: Icon(Icons.format_list_numbered_rounded, color: Colors.black,))
          ]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(width / 50),
                physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: 14,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.only(left: 13,right: 13),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            if(await msgBoxYesNo('Confirmation ', 'Supprimer ce nom de mesure ?', context)){
                              setState(() {
                                isLoading = true;
                              });
                              await Future.delayed(Duration(seconds: 2));
                              print('Noms de mesure ${index+1} Supprimé');
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              print('Noms de mesure ${index+1} pas supprimé');
                            };
                          },
                          icon: CupertinoIcons.delete,
                          label: 'Supprimer',
                          backgroundColor: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(15),
                        )
                      ],
                    ),
                    child: InkWell(
                      splashColor: Colors.orange.withOpacity(0.1),
                      onTap: (){print('ça marche');},
                      child: ListTile(
                        title: textWorkSans('Nom de mesure ${index + 1}', 17, Colors.black, TextAlign.left),
                        //subtitle: Visibility(child: textRaleway('mon sous titre', 15, Colors.black, TextAlign.left),visible: true,),
                        /*trailing: IconButton(icon: Icon(Icons.delete_sharp),color: Colors.black45,
                          onPressed: (){
                            //Navigator.pop(context);
                          },
                        ),*/
                      ),
                    ),
                  ),
                )
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: textRaleway('14 noms de mesures', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kProcouture_green,
        onPressed: () async { await showDialog(context: context, barrierDismissible: false, builder: (context)=> NomMesureSavePage());},
        child: Icon(Icons.add,color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
