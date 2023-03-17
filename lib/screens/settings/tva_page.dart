import 'package:flutter/material.dart';
import 'package:procouture/utils/constants/color_constants.dart';

import '../../widgets/custom_text.dart';

class TvaPage extends StatefulWidget {
  const TvaPage({Key? key}) : super(key: key);

  @override
  State<TvaPage> createState() => _TvaPageState();
}

class _TvaPageState extends State<TvaPage> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: textLato('Taux de TVA', 20, Colors.black, TextAlign.center),
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new),onPressed: ()=> Navigator.of(context).pop(),color: Colors.black,),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(width / 30),
          physics:
          BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) => InkWell(
            splashColor: Colors.orange.withOpacity(0.1),
            onTap: (){print('ça marche');},
            child: ListTile(
              title: textWorkSans('Option ${index + 1}', 17, Colors.black, TextAlign.left),
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
