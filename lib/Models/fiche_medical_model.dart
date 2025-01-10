class MedicalRecord {
  String id;
  String nom;
  String prenom;
  DateTime dateNaissance;
  String sexe;
  String adresse;
  String numeroTelephone;
  double poids;
  double taille;
  String maladiesChroniques;
  String antecedentsChirurgicaux;
  String allergies;
  String vaccinations;
  List<Medicament> medicaments;
  List<Examen> examens;
  String notesObservations;

  MedicalRecord({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.sexe,
    required this.adresse,
    required this.numeroTelephone,
    required this.poids,
    required this.taille,
    required this.maladiesChroniques,
    required this.antecedentsChirurgicaux,
    required this.allergies,
    required this.vaccinations,
    required this.medicaments,
    required this.examens,
    required this.notesObservations,
  });



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance.toIso8601String(),
      'sexe': sexe,
      'adresse': adresse,
      'numeroTelephone': numeroTelephone,
      'poids': poids,
      'taille': taille,
      'maladiesChroniques': maladiesChroniques,
      'antecedentsChirurgicaux': antecedentsChirurgicaux,
      'allergies': allergies,
      'vaccinations': vaccinations,
      'medicaments': medicaments.map((m) => m.toJson()).toList(),
      'examens': examens.map((e) => e.toJson()).toList(),
      'notesObservations': notesObservations,
    };
  }

  // Create a MedicalRecord from a map
  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: DateTime.parse(json['dateNaissance']),
      sexe: json['sexe'],
      adresse: json['adresse'],
      numeroTelephone: json['numeroTelephone'],
      poids: json['poids'],
      taille: json['taille'],
      maladiesChroniques: json['maladiesChroniques'],
      antecedentsChirurgicaux: json['antecedentsChirurgicaux'],
      allergies: json['allergies'],
      vaccinations: json['vaccinations'],
      medicaments: (json['medicaments'] as List).map((i) => Medicament.fromJson(i)).toList(),
      examens: (json['examens'] as List).map((i) => Examen.fromJson(i)).toList(),
      notesObservations: json['notesObservations'],
    );
  }
}

class Medicament {
  String nom;
  String posologie;
  String frequence;

  Medicament({
    required this.nom,
    required this.posologie,
    required this.frequence,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'posologie': posologie,
      'frequence': frequence,
    };
  }

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      nom: json['nom'],
      posologie: json['posologie'],
      frequence: json['frequence'],
    );
  }
}

class Examen {
  String type;
  String resultat;

  Examen({
    required this.type,
    required this.resultat,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'resultat': resultat,
    };
  }

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      type: json['type'],
      resultat: json['resultat'],
    );
  }
}
