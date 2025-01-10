class CertificatMedical {
  String id;
  String type;
  String nom;
  String prenom;
  int age;
  String sexe;
  DateTime du;
  DateTime au;
  String patientId;

  CertificatMedical({
    required this.id,
    required this.type,
    required this.nom,
    required this.prenom,
    required this.age,
    required this.sexe,
    required this.du,
    required this.au,
    required this.patientId,
  });



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'nom': nom,
      'prenom': prenom,
      'age': age,
      'sexe': sexe,
      'du': du.toIso8601String(),
      'au': au.toIso8601String(),
      'patientId': patientId,
    };
  }


  factory CertificatMedical.fromJson(Map<String, dynamic> json) {
    return CertificatMedical(
      id: json['id'],
      type: json['type'],
      nom: json['nom'],
      prenom: json['prenom'],
      age: json['age'],
      sexe: json['sexe'],
      du: DateTime.parse(json['du']),
      au: DateTime.parse(json['au']),
      patientId: json['patientId'],
    );
  }
}
