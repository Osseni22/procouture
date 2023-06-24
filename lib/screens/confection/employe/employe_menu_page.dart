import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/screens/confection/employe/avance_page.dart';
import 'package:procouture/screens/confection/employe/employes_page.dart';
import 'package:procouture/screens/confection/employe/paiements_page.dart';
import 'package:procouture/screens/confection/employe/taches_libres_page.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'dart:ui';

import '../../../widgets/default_app_bar.dart';

class EmployeMenuPage extends StatefulWidget {
  @override
  _EmployeMenuPageState createState() => _EmployeMenuPageState();
}

class _EmployeMenuPageState extends State<EmployeMenuPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: -30, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: myDefaultAppBar('Gestion du personnel',context),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// ListView
          ListView(
            //physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              SizedBox(height: _height * 0.15,),
              homePageCardsGroup(
                Color(0xfff37736),
                CupertinoIcons.person_fill,
                'Employés',
                context,
                EmployePage(),
                Color(0xffFF6D6D),
                Icons.task_outlined,
                'Tâches \nLibres',
                TachesLibresPage(),
              ),
              homePageCardsGroup(
                Colors.lightGreen,
                Icons.wallet,
                'Paiements',
                context,
                PaiementPage(),
                Color(0xffffa700),
                Icons.payments_outlined,
                'Avances',
                AvancePage(),),
            ],
          ),
        ],
      ),
    );
  }

  Widget homePageCardsGroup(
      Color color,
      IconData icon,
      String title,
      BuildContext context,
      Widget route,
      Color color2,
      IconData icon2,
      String title2,
      Widget route2) {
    double _w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: _w / 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homePageCard(color, icon, title, context, route),
          homePageCard(color2, icon2, title2, context, route2),
        ],
      ),
    );
  }

  Widget homePageCard(Color color, IconData icon, String title,
      BuildContext context, Widget route) {
    double _w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return route;
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(15),
            height: _w / 2,
            width: _w / 2.4,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xff040039).withOpacity(.15),
                  blurRadius: 99,
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(),
                Container(
                  height: _w / 6,
                  width: _w / 6,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color.withOpacity(.6),
                    size: 32,
                  ),
                ),
                Text(
                  title,
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(.5),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Raleway'
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget blurTheStatusBar(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          height: _w / 18,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class RouteWhereYouGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(.5),
        title: Text(
          'Tâches',
          style: TextStyle(
              color: Colors.black.withOpacity(.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black.withOpacity(.8),
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}
