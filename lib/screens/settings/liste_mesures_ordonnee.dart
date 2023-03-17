import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_app_bar.dart';
import 'package:procouture/utils/globals/some_lists.dart';

class ListeMesuresOrdonnees extends StatefulWidget {
  const ListeMesuresOrdonnees({Key? key}) : super(key: key);

  @override
  State<ListeMesuresOrdonnees> createState() => _ListeMesuresOrdonneesState();
}

class _ListeMesuresOrdonneesState extends State<ListeMesuresOrdonnees> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Ordonner les noms de mesures', context,textSize: 17,
          actions: [
            TextButton(onPressed: (){}, child: textOpenSans('OK', 20, Colors.green, TextAlign.start, fontWeight: FontWeight.bold))
          ]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            height: 40,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10)
            ),
            //color: Colors.blue,
            child: textRaleway('Faites déplacer les lignes pour re-ordonner la liste', 12, Colors.grey, TextAlign.center),
          ),
          SizedBox(height: 5,),
          Expanded(
              child: ReorderableListView(
                //key: ,
                  onReorder: (int oldIndex, int newIndex){
                    String myVar = '';
                    myVar = nomMesureList[oldIndex].nom!;
                    nomMesureList[oldIndex].nom = nomMesureList[newIndex].nom;
                    nomMesureList[newIndex].nom = myVar;
                      for(int i = 0; i < nomMesureList.length; i++){
                        nomMesureList[i].order = i+1;
                      }
                      setState(() {

                      });
                  },
                  children: [
                    for(int i = 0; i < nomMesureList.length; i++)
                      ListTile(
                        key: Key(nomMesureList[i].nom!),
                        title: textOpenSans(nomMesureList[i].nom!, 18, Colors.black, TextAlign.start),
                        leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: textOpenSans(nomMesureList[i].order.toString(), 17, Colors.black, TextAlign.center)
                        ),
                      ),
                  ]
              )
          )
        ],
      ),
    );
  }
}
