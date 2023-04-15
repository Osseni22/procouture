class User {
  // Member Variables
  int? id;
  String? nom;
  String? prenom;
  String? email;
  String? username;
  String? password;
  int? atelier_id;

  // Constructor
  User({required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.atelier_id,
    required this.password,
    required this.username
  });

  // Get instance data from a json data
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      atelier_id: json['atelier_id'],
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
      'username': username,
      'password': password,
    };
  }

}