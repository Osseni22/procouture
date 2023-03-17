class User {
  // Member Variables
  int? id;
  String? nom;
  String? prenom;
  String? email;
  String? token;
  int? atelier_id;

  // Constructor
  User({required this.id, required this.nom, required this.prenom, required this.email, required this.token, required this.atelier_id});

  // Get instance data from a json data
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      atelier_id: json['atelier_id'],
      token: json['token'],
    );
  }

  // Convert to Json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'atelier_id': atelier_id,
      'token': token,
    };
  }

}