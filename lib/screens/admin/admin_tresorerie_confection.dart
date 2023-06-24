import 'package:flutter/material.dart';
import 'package:procouture/widgets/default_app_bar.dart';

import '../../models/Atelier.dart';

class AdminTresorerieConfection extends StatefulWidget {
  final Atelier atelier;
  const AdminTresorerieConfection({Key? key, required this.atelier}) : super(key: key);

  @override
  State<AdminTresorerieConfection> createState() => _AdminTresorerieConfectionState();
}

class _AdminTresorerieConfectionState extends State<AdminTresorerieConfection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Trésorerie Confection', context),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
