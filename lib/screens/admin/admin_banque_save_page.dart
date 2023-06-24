import 'package:flutter/material.dart';

import '../../models/Banque.dart';

class AdminBanqueSavePage extends StatelessWidget {
  final String pageMode; Banque? banque;
  AdminBanqueSavePage({Key? key, required this.pageMode, this.banque}) : super(key: key);

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ajouter une banque",
              ),
            ),

            // buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // save button
                //MyButton(text: "Save", onPressed: onSave),

                const SizedBox(width: 8),

                // cancel button
                //MyButton(text: "Cancel", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
