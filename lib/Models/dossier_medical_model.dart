class DossierMedical {
  String id;
  String nom;
  String prenom;
  DateTime dateNaissance;
  String sexe;
  String adresse;
  String numeroTelephone;
  String antecedentsFamiliaux;
  String antecedentsPersonnels;
  String antecedentsChirurgicaux;
  List<Consultation> consultations;
  List<TestEtExamen> testsEtExamens;
  List<SuiviDesSoins> suiviDesSoins;

  DossierMedical({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.sexe,
    required this.adresse,
    required this.numeroTelephone,
    required this.antecedentsFamiliaux,
    required this.antecedentsPersonnels,
    required this.antecedentsChirurgicaux,
    required this.consultations,
    required this.testsEtExamens,
    required this.suiviDesSoins,
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
      'antecedentsFamiliaux': antecedentsFamiliaux,
      'antecedentsPersonnels': antecedentsPersonnels,
      'antecedentsChirurgicaux': antecedentsChirurgicaux,
      'consultations': consultations.map((c) => c.toJson()).toList(),
      'testsEtExamens': testsEtExamens.map((te) => te.toJson()).toList(),
      'suiviDesSoins': suiviDesSoins.map((ss) => ss.toJson()).toList(),
    };
  }




  factory DossierMedical.fromJson(Map<String, dynamic> json) {
    return DossierMedical(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: DateTime.parse(json['dateNaissance']),
      sexe: json['sexe'],
      adresse: json['adresse'],
      numeroTelephone: json['numeroTelephone'],
      antecedentsFamiliaux: json['antecedentsFamiliaux'],
      antecedentsPersonnels: json['antecedentsPersonnels'],
      antecedentsChirurgicaux: json['antecedentsChirurgicaux'],
      consultations: (json['consultations'] as List).map((i) => Consultation.fromJson(i)).toList(),
      testsEtExamens: (json['testsEtExamens'] as List).map((i) => TestEtExamen.fromJson(i)).toList(),
      suiviDesSoins: (json['suiviDesSoins'] as List).map((i) => SuiviDesSoins.fromJson(i)).toList(),
    );
  }
}



class Consultation {
  DateTime date;
  String motif;
  String observations;
  String traitements;

  Consultation({
    required this.date,
    required this.motif,
    required this.observations,
    required this.traitements,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'motif': motif,
      'observations': observations,
      'traitements': traitements,
    };
  }

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      date: DateTime.parse(json['date']),
      motif: json['motif'],
      observations: json['observations'],
      traitements: json['traitements'],
    );
  }
}

class TestEtExamen {
  String type;
  String resultat;

  TestEtExamen({
    required this.type,
    required this.resultat,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'resultat': resultat,
    };
  }

  factory TestEtExamen.fromJson(Map<String, dynamic> json) {
    return TestEtExamen(
      type: json['type'],
      resultat: json['resultat'],
    );
  }
}

class SuiviDesSoins {
  String traitementsEnCours;
  String suiviDesPrescriptions;
  String notesEvolution;

  SuiviDesSoins({
    required this.traitementsEnCours,
    required this.suiviDesPrescriptions,
    required this.notesEvolution,
  });

  Map<String, dynamic> toJson() {
    return {
      'traitementsEnCours': traitementsEnCours,
      'suiviDesPrescriptions': suiviDesPrescriptions,
      'notesEvolution': notesEvolution,
    };
  }

  factory SuiviDesSoins.fromJson(Map<String, dynamic> json) {
    return SuiviDesSoins(
      traitementsEnCours: json['traitementsEnCours'],
      suiviDesPrescriptions: json['suiviDesPrescriptions'],
      notesEvolution: json['notesEvolution'],
    );
  }
}
