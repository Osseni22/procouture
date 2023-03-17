import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:procouture/screens/confection/client/client_matiere_save_page.dart';
import 'package:procouture/screens/confection/client/client_rdv_save_page.dart';

import '../../../components/message_box.dart';
import '../../../widgets/custom_text.dart';

class ClientMesurePage extends StatefulWidget {
  const ClientMesurePage({super.key});

  @override
  State<ClientMesurePage> createState() => _ClientMesurePageState();
}

class _ClientMesurePageState extends State<ClientMesurePage> {

  bool searchBoolean = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: textMontserrat('Mesures', 18, Colors.black, TextAlign.center),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading? LinearProgressIndicator(backgroundColor: Colors.transparent,) : SizedBox(),
          Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.only(left: 23, right: 23, top: 10),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              if(await msgBoxYesNo('Confirmation ', 'Supprimer cette mesure ?', context)){
                                setState(() {
                                  isLoading = true;
                                });
                                await Future.delayed(Duration(seconds: 2));
                                print("${index+1} Supprimé");
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                print("${index+1} pas supprimé");
                              };
                            },
                            icon: CupertinoIcons.delete,
                            label: 'Supprimer',
                            backgroundColor: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(15),
                          )
                        ],
                      ),
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10,),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textMontserrat('Mesure de Chemise ${index+1}', 16, Colors.grey.shade600, TextAlign.left,fontWeight: FontWeight.w600),
                                    //const SizedBox(height: 2,),
                                    textMontserrat('Enregistré le 31/12/2023', 14, Colors.black, TextAlign.left),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              )
          ),
          Container(
              alignment: Alignment.centerRight,
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: textRaleway('Nom du client', 13, Colors.black, TextAlign.start)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7.0,
        onPressed: (){/*Navigator.push(context, MaterialPageRoute(builder: (context) => ClientMatiereSave()));*/},
        isExtended: true,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void startLoading(){
    setState(() {
      isLoading = true;
    });
  }
  void endLoading(){
    setState(() {
      isLoading = false;
    });
  }

}