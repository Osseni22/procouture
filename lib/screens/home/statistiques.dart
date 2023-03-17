import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';

import '../../widgets/default_app_bar.dart';
import 'package:pie_chart/pie_chart.dart';

class Statistiques extends StatefulWidget {
  const Statistiques({Key? key}) : super(key: key);

  @override
  State<Statistiques> createState() => _StatistiquesState();
}

class _StatistiquesState extends State<Statistiques> {

  int choice = 0;
  Map<String, double> dataMap = {
    "Chemise 1" : 18.47,
    "Chemise tunique courte Femme" : 12.47,
    "Veste en pagne" : 14.47,
    "Robe courte en pagne" : 2.32,
    "Gilet de veste" : 6.50,
  };

  List<Color> colorList = [
    Colors.blueAccent,
    Colors.amber,
    Colors.indigo,
    Colors.redAccent,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Statistiques', context),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            child: textMontserrat('Modèles les plus commandés', 17, Colors.black, TextAlign.center, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Center(
              child: PieChart(
                dataMap : dataMap,
                colorList: colorList,
                chartType: ChartType.disc,
                chartRadius: MediaQuery.of(context).size.width * 0.9,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                  showChartValueBackground: true,
                ),
                legendOptions: const LegendOptions(
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(fontSize: 12, fontFamily: 'Montserrat'),
                  legendPosition: LegendPosition.bottom,
                  showLegendsInRow: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
