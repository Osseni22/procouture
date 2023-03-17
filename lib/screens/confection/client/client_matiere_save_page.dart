import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../../utils/constants/color_constants.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/default_app_bar.dart';

class ClientMatiereSave extends StatefulWidget {
  const ClientMatiereSave({Key? key}) : super(key: key);

  @override
  State<ClientMatiereSave> createState() => _ClientMatiereSaveState();
}

class _ClientMatiereSaveState extends State<ClientMatiereSave> {

  TextEditingController dateTimeCtrl = TextEditingController();
  final format = DateFormat("dd/MM/yyyy");

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  void takePicture(ImageSource source) async {
    final pickleFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickleFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: myDefaultAppBar('Fiche Matiere', context),
        body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        alignment: Alignment.center,
                        //color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Image du produit
                            textRaleway('Image de la matière', 14, Colors.black, TextAlign.center),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey.shade400),
                                      image: DecorationImage(
                                          image: _imageFile == null ? AssetImage('assets/images/shirt_logo.png') as ImageProvider : FileImage(File(_imageFile!.path)),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                  //child: _imageFile == null ? Image.asset('assets/images/shirt_logo.png',fit: BoxFit.cover) : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                                )
                              ],
                            ),
                            SizedBox(height: 5,),
                            // Image de selection
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey.withOpacity(0.5))
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      takePicture(ImageSource.camera);
                                    },
                                    icon: Icon(Icons.photo_camera, color: Colors.grey.shade500,),
                                  ),
                                ),
                                const SizedBox(width: 15,),
                                Container(
                                  height: 40,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey.withOpacity(0.5))
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      takePicture(ImageSource.gallery);
                                    },
                                    icon: Icon(Icons.photo, color: Colors.grey.shade500),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 270,
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
                              child: DateTimeField(
                                style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                                format: format,
                                controller: dateTimeCtrl,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Date',
                                    hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                                onShowPicker: (context, currentValue) async {
                                  return await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                },
                              ),
                            ),
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
                                    hintText: 'Matiere',
                                    hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                              ),
                              child: TextField(
                                //controller: ,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Quantité',
                                    hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.grey)
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                //border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.08)))
                              ),
                              child: TextField(
                                //controller: ,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Marque',
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
