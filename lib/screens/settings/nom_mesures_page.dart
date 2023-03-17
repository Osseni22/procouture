import 'package:flutter/material.dart';
import 'package:procouture/components/mesures_homme_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';

import '../../components/mesures_femme_page.dart';
import '../../widgets/custom_text.dart';

class NomsMesurePage extends StatefulWidget {
  const NomsMesurePage({Key? key}) : super(key: key);

  @override
  State<NomsMesurePage> createState() => _NomsMesurePageState();
}

class _NomsMesurePageState extends State<NomsMesurePage> {

  final kTabPages = <Widget> [
    MesuresHommePage(),
    MesuresFemmePage(),
  ];

  final kTabs = <Tab> [
     Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.man_rounded,color: Colors.black,),
          const SizedBox(width: 12),
          textRaleway('Homme', 18, Colors.black, TextAlign.start),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.woman_rounded,color: Colors.black,),
          const SizedBox(width: 12),
          textRaleway('Femme', 18, Colors.black, TextAlign.start),
        ],
      ),
    ),
    //const Tab(icon: Icon(Icons.woman_rounded,color: Colors.green,size: 40),/*child: Text('Femme',style: TextStyle(color: Colors.green))*/)
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: kTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: textLato('Noms de mesures', 20, Colors.black, TextAlign.center),
            centerTitle: true,
            elevation: 0.2,
            backgroundColor: Colors.white,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios_new),onPressed: ()=> Navigator.of(context).pop(),color: Colors.black,),
            bottom: TabBar(tabs: kTabs),
          ),
          body: TabBarView(
            children: kTabPages,
          ),
        )
    );
  }
}
