import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/color_constants.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/default_app_bar.dart';

class ClientRdvSave extends StatefulWidget {
  const ClientRdvSave({Key? key}) : super(key: key);

  @override
  State<ClientRdvSave> createState() => _ClientRdvSaveState();
}

class _ClientRdvSaveState extends State<ClientRdvSave> {

  TextEditingController dateTimeCtrl = TextEditingController();
  final format = DateFormat("dd/MM/yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: myDefaultAppBar('Fiche Rendez-Vous', context),
        body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 245,
                        padding:  EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                              ),
                              child: TextField(
                                //controller: ,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Objet (Titre)',
                                    hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                              ),
                              child: DateTimeField(
                                format: format,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Date et Heure',
                                    hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                                onShowPicker: (context, currentValue) async {
                                  return await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100),
                                  ).then((DateTime? date) async {
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.combine(date, time);
                                    } else {
                                      return currentValue;
                                    }
                                  }
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 100,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                              ),
                              child: TextField(
                                //controller: ,
                                maxLines: 5,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Contenu',
                                    hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 35,),
                      GestureDetector(
                        onTap: (){print('OK');},
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: double.infinity,
                          padding:  EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: kProcouture_green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: textMontserrat('Valider', 18, Colors.white, TextAlign.center),
                        ),
                      )
                    ]
                ),
              ),
            )
        )
    );
  }
}
