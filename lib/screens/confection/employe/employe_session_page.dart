import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_box_shadow.dart';
import 'dart:ui';

import '../../../widgets/default_app_bar.dart';

class EmployeSession extends StatefulWidget {
  @override
  _EmployeSessionState createState() => _EmployeSessionState();
}

class _EmployeSessionState extends State<EmployeSession>
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
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myDefaultAppBar('Session Employé',context),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// ListView
          ListView(
            //physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(_w / 17, _w / 20, _w / 17, _w / 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textMontserrat("OSSENI ABDEL AZIZ", 20, Colors.black, TextAlign.start,fontWeight: FontWeight.w600),
                    SizedBox(height: 10),
                    textMontserrat('Poste : Couturier', 15, Colors.black54, TextAlign.start,fontWeight: FontWeight.w500),
                    SizedBox(height: 3),
                    textMontserrat('Salaire : 200 000 FCFA', 15, Colors.black45, TextAlign.start,fontWeight: FontWeight.w500),
                    SizedBox(height: 3),
                    textMontserrat('Commission : 120 000 FCFA', 15, Colors.black45, TextAlign.start,fontWeight: FontWeight.w500),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              homePageCardsGroup(
                Color(0xfff37736),
                Icons.task_rounded,
                'Tâches (Commission)',
                context,
                RouteWhereYouGo(),
                Color(0xffFF6D6D),
                Icons.task_outlined,
                'Tâches \nLibres',
                RouteWhereYouGo(),
              ),
              homePageCardsGroup(
                  Colors.lightGreen,
                  Icons.wallet,
                  'Paiements',
                  context,
                  RouteWhereYouGo(),
                  Color(0xffffa700),
                  Icons.payments_outlined,
                  'Avances',
                  RouteWhereYouGo()),
              /*homePageCardsGroup(
                  Color(0xff63ace5),
                  Icons.ad_units_outlined,
                  'Example example example',
                  context,
                  RouteWhereYouGo(),
                  Color(0xfff37736),
                  Icons.article_sharp,
                  'Example example',
                  RouteWhereYouGo()),
              homePageCardsGroup(
                  Color(0xffFF6D6D),
                  Icons.android,
                  'Example example',
                  context,
                  RouteWhereYouGo(),
                  Colors.lightGreen,
                  Icons.text_format,
                  'Example',
                  RouteWhereYouGo()),
              homePageCardsGroup(
                  Color(0xffffa700),
                  Icons.text_fields,
                  'Example',
                  context,
                  RouteWhereYouGo(),
                  Color(0xff63ace5),
                  Icons.calendar_today_sharp,
                  'Example example',
                  RouteWhereYouGo()),*/
             // SizedBox(height: _w / 20),
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
