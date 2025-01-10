import 'package:cabinet_medical_v2/Models/fiche_medical_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';





class MedicalRecordForm extends StatefulWidget {
  final Function(MedicalRecord) onSubmit;
  final MedicalRecord? existingRecord;

  const MedicalRecordForm({super.key, required this.onSubmit, this.existingRecord});

  @override
  State<MedicalRecordForm> createState() => _MedicalRecordFormState();
}

class _MedicalRecordFormState extends State<MedicalRecordForm> {
  final _formKey = GlobalKey<FormState>();
  late String nom;
  late String prenom;
  late DateTime dateNaissance;
  late String sexe;
  late String adresse;
  late String numeroTelephone;
  late double poids;
  late double taille;
  late String maladiesChroniques;
  late String antecedentsChirurgicaux;
  late String allergies;
  late String vaccinations;
  List<Medicament> medicaments = [];
  List<Examen> examens = [];
  late String notesObservations;

  @override
  void initState() {
    super.initState();
    dateNaissance = widget.existingRecord?.dateNaissance ?? DateTime.now();
    if (widget.existingRecord != null) {
      nom = widget.existingRecord!.nom;
      prenom = widget.existingRecord!.prenom;
      sexe = widget.existingRecord!.sexe;
      adresse = widget.existingRecord!.adresse;
      numeroTelephone = widget.existingRecord!.numeroTelephone;
      poids = widget.existingRecord!.poids;
      taille = widget.existingRecord!.taille;
      maladiesChroniques = widget.existingRecord!.maladiesChroniques;
      antecedentsChirurgicaux = widget.existingRecord!.antecedentsChirurgicaux;
      allergies = widget.existingRecord!.allergies;
      vaccinations = widget.existingRecord!.vaccinations;
      medicaments = widget.existingRecord!.medicaments;
      examens = widget.existingRecord!.examens;
      notesObservations = widget.existingRecord!.notesObservations;
    } else {
      nom = '';
      prenom = '';
      sexe = '';
      adresse = '';
      numeroTelephone = '';
      poids = 0.0;
      taille = 0.0;
      maladiesChroniques = '';
      antecedentsChirurgicaux = '';
      allergies = '';
      vaccinations = '';
      notesObservations = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateNaissance,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateNaissance = pickedDate;
      });
    }
  }

  void _addMedicament() {
    setState(() {
      medicaments.add(Medicament(nom: '', posologie: '', frequence: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    return Scaffold(
      appBar:  AppBar(
        title: const Text('Fiche Médicale', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        )),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Icon(Icons.arrow_back_outlined, color: Colors.white)
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [






              const Text('Informations Personnelles',
                  style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
              _buildTextField('Nom', (value) => nom = value!,
                  initialValue: nom),
              _buildTextField('Prénom', (value) => prenom = value!,
                  initialValue: prenom),
              ListTile(
                title: Text('Date de Naissance: ${formatter.format(dateNaissance)}'),
                trailing: const Icon(Icons.keyboard_arrow_down),
                onTap: () => _selectDate(context),
              ),
              _buildTextField('Sexe', (value) => sexe = value!,
                  initialValue: sexe),
              _buildTextField('Adresse', (value) => adresse = value!,
                  initialValue: adresse),
              _buildTextField(
                  'Numéro de Téléphone', (value) => numeroTelephone = value!,
                  initialValue: numeroTelephone,
                  keyboardType: TextInputType.phone),
              _buildTextField(
                  'Poids (kg)', (value) => poids = double.parse(value!),
                  initialValue: poids.toString(),
                  keyboardType: TextInputType.number),
              _buildTextField(
                  'Taille (cm)', (value) => taille = double.parse(value!),
                  initialValue: taille.toString(),
                  keyboardType: TextInputType.number),

              const SizedBox(height: 20),




              // ignore: prefer_const_constructors
              Text('Antécédents Médicaux',
                  style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
              _buildTextField(
                  'Maladies Chroniques', (value) => maladiesChroniques = value!,
                  initialValue: maladiesChroniques),
              _buildTextField('Antécédents Chirurgicaux',
                  (value) => antecedentsChirurgicaux = value!,
                  initialValue: antecedentsChirurgicaux),
              _buildTextField('Allergies', (value) => allergies = value!,
                  initialValue: allergies),
              _buildTextField('Vaccinations', (value) => vaccinations = value!,
                  initialValue: vaccinations),

              const SizedBox(height: 20),




              // ignore: prefer_const_constructors
              Text('Liste des Médicaments',
                  style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: medicaments.length,
                itemBuilder: (context, index) {
                  return _buildMedicamentTile(index);
                },
              ),
              TextButton(
                onPressed: _addMedicament,
                child: const Text('Ajouter un Médicament'),
              ),

              const SizedBox(height: 20),






              // ignore: prefer_const_constructors
              Text('Résultats d\'Examen',
                  style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: examens.length,
                itemBuilder: (context, index) {
                  return _buildExamenTile(index);
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    examens.add(Examen(type: '', resultat: ''));
                  });
                },
                child: const Text('Ajouter un Examen'),
              ),

              const SizedBox(height: 20),




              // ignore: prefer_const_constructors
              Text('Notes et Observations',
                  style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
              _buildTextField('Notes et Observations',
                  (value) => notesObservations = value!,
                  initialValue: notesObservations, maxLines: 5),

              const SizedBox(height: 20),

              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor:WidgetStatePropertyAll<Color>(Colors.indigo),
                  padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final medicalRecord = MedicalRecord(
                      id: widget.existingRecord?.id ??
                          DateTime.now().toString(),
                      nom: nom,
                      prenom: prenom,
                      dateNaissance: dateNaissance,
                      sexe: sexe,
                      adresse: adresse,
                      numeroTelephone: numeroTelephone,
                      poids: poids,
                      taille: taille,
                      maladiesChroniques: maladiesChroniques,
                      antecedentsChirurgicaux: antecedentsChirurgicaux,
                      allergies: allergies,
                      vaccinations: vaccinations,
                      medicaments: medicaments,
                      examens: examens,
                      notesObservations: notesObservations,
                    );
                    widget.onSubmit(medicalRecord);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    Function(String?) onSaved, {
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border:
              const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $label';
          }
          return null;
        },
      ),
    );
  }



  Widget _buildMedicamentTile(int index) {
    return Column(
      children: [
        Text('Médicament ${index + 1}',
            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)
        ),
        _buildTextField('Nom', (value) => medicaments[index].nom = value!,
            initialValue: medicaments[index].nom),
        _buildTextField(
            'Posologie', (value) => medicaments[index].posologie = value!,
            initialValue: medicaments[index].posologie),
        _buildTextField(
            'Fréquence', (value) => medicaments[index].frequence = value!,
            initialValue: medicaments[index].frequence),
        const Divider(),
      ],
    );
  }



    Widget _buildExamenTile(int index) {
    return Column(
      children: [
        Text('Examen ${index + 1}', 
          style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)
        ),
        _buildTextField('Type d\'Examen', (value) => examens[index].type = value!, initialValue: examens[index].type),
        _buildTextField('Résultat de l\'Analyse', (value) => examens[index].resultat = value!, initialValue: examens[index].resultat),
        const Divider(),
      ],
    );
  }








}

