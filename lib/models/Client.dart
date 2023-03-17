class Client{
  // Member Variables
  int? id;
  String? ref;
  String? nom;
  String? adresse;
  String? ville;
  String? telephone1;
  String? telephone2;
  String? email;
  double? acompte;
  int? atelier_id;

  // Constructor
  Client({
    required this.id,
    required this.ref,
    required this.nom,
    required this.adresse,
    required this.ville,
    required this.telephone1,
    required this.telephone2,
    required this.email,
    required this.acompte,
    required this.atelier_id,
  });

  // Get instance data from a json data
  factory Client.fromJson(Map<String, dynamic> json){
    return Client(
      id: json['id'],
      ref: json['nom'],
      nom: json['prenom'],
      adresse: json['email'],
      ville: json['atelier_id'],
      telephone1: json['telephone1'],
      telephone2: json['telephone2'],
      email: json['email'],
      acompte: json['acompte'],
      atelier_id: json['atelier_id']
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'ref': ref,
      'nom': nom,
      'adresse': adresse,
      'ville': ville,
      'telephone1': telephone1,
      'telephone2': telephone2,
      'email': email,
      'acompte': acompte,
      'atelier_id': atelier_id,
    };
  }

}



/*
Widget formerClientListBuild(){
  return AnimationLimiter(
    child: ListView.builder(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 30),
      physics:
      BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          delay: Duration(milliseconds: 100),
          child: SlideAnimation(
            duration: Duration(milliseconds: 2500),
            curve: Curves.fastLinearToSlowEaseIn,
            child: FadeInAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 2500),
              child: Container(
                margin: EdgeInsets.all(5),
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Colors.orange.withOpacity(0.1),
                      onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SessionPage()));},
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: textLato('Client $index'.substring(0,1).toUpperCase(), 18, Colors.black, TextAlign.center),
                        ),
                        title: textLato('Client ${index+1}', 17, Colors.black, TextAlign.left),
                        subtitle: textWorkSans('00 11 22 33 44 55', 12, Colors.black, TextAlign.left),
                        trailing: Container(
                          width: 100,
                          height: 80,
                          //color: Colors.blue,
                          //alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.grey[100],
                                  child: IconButton(
                                    onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ClientSave()));},
                                    icon: Icon(Icons.edit_note_rounded),color: Colors.black,
                                  )
                              ),
                              const SizedBox(width: 8,),
                              CircleAvatar(
                                  backgroundColor: Colors.red[400],
                                  child: IconButton(
                                    onPressed: (){},
                                    icon: Icon(CupertinoIcons.delete_solid),color: Colors.white,
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}*/
