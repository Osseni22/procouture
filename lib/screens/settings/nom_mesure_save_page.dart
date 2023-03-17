import 'package:flutter/material.dart';
import 'package:procouture/widgets/custom_text.dart';
class NomMesureSavePage extends StatelessWidget {
  const NomMesureSavePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController controller = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder( // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
          bottom: Radius.circular(10.0),
        ),
      ),
      title: textMontserrat('Enreg. Nom mesure', 17, Colors.black, TextAlign.start, fontWeight: FontWeight.w500),
      content: Container(
        height: 55,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Nom de mesure',
              hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
          ),
        ),
      ),
      actions: [
        Container(
          width: 100,
          height: 40,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.1)
            ),
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: textMontserrat('Annuler',13,Colors.black,TextAlign.start, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: 100,
          height: 40,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.2)
            ),
            onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
            child:textMontserrat('Valider',13,Colors.green.withOpacity(0.8),TextAlign.start, fontWeight: FontWeight.w800),

          ),
        ),
      ],
    );
  }
}
