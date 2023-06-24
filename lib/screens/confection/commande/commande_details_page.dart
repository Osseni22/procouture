import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:procouture/screens/confection/commande/ligne_cmde_details_page.dart';
import 'package:procouture/utils/constants/color_constants.dart';
import 'package:procouture/utils/globals/global_var.dart';
import 'package:procouture/widgets/custom_text.dart';
import 'package:procouture/widgets/default_box_shadow.dart';

import '../../../models/Commande.dart';
import '../../../models/LigneCommande.dart';

class CommandeDetailsPage extends StatefulWidget {
  final Commande commande; final List<LigneCommande>? ligneCmdes;
  CommandeDetailsPage({Key? key, required this.commande, this.ligneCmdes}) : super(key: key);

  @override
  State<CommandeDetailsPage> createState() => _CommandeDetailsPageState();
}

class _CommandeDetailsPageState extends State<CommandeDetailsPage> {

  LigneCommande? selectedModele;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Colors.grey.shade100,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: width,
            height: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/couture-nuls-carre.jpg')
              )
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35,),
                  IconButton(
                    onPressed: (){ Navigator.pop(context);},
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,)
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: width-80),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: width-120),
            //padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 300,
                      width: 300,
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 3,),
                          textMontserrat('Commande N°${widget.commande.id}', 17, kProcouture_green, TextAlign.start, fontWeight: FontWeight.bold),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Référence:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat(widget.commande.ref!.toUpperCase(), 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Client:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat(widget.commande.client!.toUpperCase(), 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Montant TTC:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat("${NumberFormat('#,###', 'fr_FR').format(widget.commande.montant_ttc)} ${CnxInfo.symboleMonnaie}", 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Montant réglé:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat("${NumberFormat('#,###', 'fr_FR').format(widget.commande.montant_recu)} ${CnxInfo.symboleMonnaie}", 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Montant restant:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat("${NumberFormat('#,###', 'fr_FR').format(widget.commande.montant_ttc!- widget.commande.montant_recu!)} ${CnxInfo.symboleMonnaie}", 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Remise:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat("${NumberFormat('#,###', 'fr_FR').format(widget.commande.remise)} ${CnxInfo.symboleMonnaie}", 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Etat:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat(widget.commande.etat!, 13, Colors.blueGrey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Date commande:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat(Globals.convertDateEnToFr(widget.commande.date_commande!).toString(), 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textMontserrat('Date livraison:', 13, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textMontserrat(Globals.convertDateEnToFr(widget.commande.date_prev_livraison!).toString(), 13, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),
                          SizedBox(height: 15,)
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textWorkSans('Taux TVA:', 14, Colors.black, TextAlign.start),
                              SizedBox(width: 5,),
                              textWorkSans(widget.commande.tva!.taux.toString(), 14, Colors.grey, TextAlign.start, fontWeight: FontWeight.w700),
                            ],
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  textMontserrat('Modèles commandés', 14, Colors.black, TextAlign.center),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 15),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 190,
                      //color: Colors.blue,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.ligneCmdes!.length,
                        itemBuilder: (BuildContext context, int index) => Container(
                          alignment: Alignment.center,
                          //padding: EdgeInsets.only(right: 14),
                          margin: const EdgeInsets.only(right: 10),
                          //height: 150,
                          width: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              //boxShadow: [kDefaultBoxShadow3],
                              color: Colors.white
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    print(widget.ligneCmdes);
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => LigneCmdeDetailsPage(ligneCommande: widget.ligneCmdes![index])));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: widget.ligneCmdes![index].image_av == null ?
                                        AssetImage('assets/images/shirt_logo.png') as ImageProvider : NetworkImage(widget.ligneCmdes![index].image_av!),
                                      )
                                    ),
                                  ),
                                )
                              ),
                              Container(
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  //color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textMontserrat(widget.ligneCmdes![index].product!.libelle!, 10, Colors.black, TextAlign.start,fontWeight: FontWeight.w500),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 5),
                                      child: textRaleway(
                                        "${widget.ligneCmdes![index].qte} x ${NumberFormat('#,###','fr_FR').format(widget.ligneCmdes![index].prix!/widget.ligneCmdes![index].qte!)}", 10, Colors.black, TextAlign.end)
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container bottomSheetInfoModele(){
    return Container(

    );
  }
}
