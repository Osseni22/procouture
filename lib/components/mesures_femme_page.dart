import 'package:flutter/material.dart';
import 'package:procouture/utils/constants/color_constants.dart';

import '../../widgets/custom_text.dart';

class MesuresFemmePage extends StatefulWidget {
  const MesuresFemmePage({Key? key}) : super(key: key);

  @override
  State<MesuresFemmePage> createState() => _MesuresFemmePageState();
}

class _MesuresFemmePageState extends State<MesuresFemmePage> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: ListView.builder(
            padding: EdgeInsets.all(width / 50),
            physics:
            BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) => InkWell(
              splashColor: Colors.orange.withOpacity(0.1),
              onTap: (){print('ça marche');},
              child: ListTile(
                title: textWorkSans('Nom de mesure ${index + 1}', 17, Colors.black, TextAlign.left),
                //subtitle: Visibility(child: textRaleway('mon sous titre', 15, Colors.black, TextAlign.left),visible: true,),
                trailing: IconButton(icon: Icon(Icons.delete_sharp),color: Colors.black45,
                  onPressed: (){
                    //Navigator.pop(context);
                  },
                ),
              ),
            )
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kProcouture_green,
        onPressed: (){},
        child: Icon(Icons.add,color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
