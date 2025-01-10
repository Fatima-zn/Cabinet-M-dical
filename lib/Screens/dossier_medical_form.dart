import 'package:cabinet_medical_v2/Models/dossier_medical_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DossierMedicalForm extends StatefulWidget {
  final Function(DossierMedical) onSubmit;
  final DossierMedical? existingRecord;

  const DossierMedicalForm(
      {super.key, required this.onSubmit, this.existingRecord});

  @override
  State<DossierMedicalForm> createState() => _DossierMedicalFormState();
}

class _DossierMedicalFormState extends State<DossierMedicalForm> {
  final _formKey = GlobalKey<FormState>();
  late String nom;
  late String prenom;
  late DateTime dateNaissance;
  late String sexe;
  late String adresse;
  late String numeroTelephone;
  late String antecedentsFamiliaux;
  late String antecedentsPersonnels;
  late String antecedentsChirurgicaux;
  List<Consultation> consultations = [];
  List<TestEtExamen> testsEtExamens = [];
  List<SuiviDesSoins> suiviDesSoins = [];

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
      antecedentsFamiliaux = widget.existingRecord!.antecedentsFamiliaux;
      antecedentsPersonnels = widget.existingRecord!.antecedentsPersonnels;
      antecedentsChirurgicaux = widget.existingRecord!.antecedentsChirurgicaux;
      consultations = widget.existingRecord!.consultations;
      testsEtExamens = widget.existingRecord!.testsEtExamens;
      suiviDesSoins = widget.existingRecord!.suiviDesSoins;
    } else {
      nom = '';
      prenom = '';
      sexe = '';
      adresse = '';
      numeroTelephone = '';
      antecedentsFamiliaux = '';
      antecedentsPersonnels = '';
      antecedentsChirurgicaux = '';
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

  void _addConsultation() {
    setState(() {
      consultations.add(Consultation(
          date: DateTime.now(), motif: '', observations: '', traitements: ''));
    });
  }

  void _addTestEtExamen() {
    setState(() {
      testsEtExamens.add(TestEtExamen(type: '', resultat: ''));
    });
  }

  void _addSuiviDesSoins() {
    setState(() {
      suiviDesSoins.add(SuiviDesSoins(
          traitementsEnCours: '',
          suiviDesPrescriptions: '',
          notesEvolution: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dossier Médical',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
                width: 60,
                height: 60,
                child: Icon(Icons.arrow_back_outlined, color: Colors.white))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Informations d\'identification',
                  style: TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),
              const Text('Historique médical',
                  style: TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold)),
              _buildTextField('Antécédents Familiaux',
                  (value) => antecedentsFamiliaux = value!,
                  initialValue: antecedentsFamiliaux),
              _buildTextField('Antécédents Personnels',
                  (value) => antecedentsPersonnels = value!,
                  initialValue: antecedentsPersonnels),
              _buildTextField('Antécédents Chirurgicaux',
                  (value) => antecedentsChirurgicaux = value!,
                  initialValue: antecedentsChirurgicaux),
              const SizedBox(height: 20),
              const Text('Consultations médicales',
                  style: TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: consultations.length,
                itemBuilder: (context, index) {
                  return _buildConsultationTile(index);
                },
              ),
              TextButton(
                onPressed: _addConsultation,
                child: const Text('Ajouter une Consultation'),
              ),
              const SizedBox(height: 20),
              const Text('Résultats de tests et examens',
                  style: TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: testsEtExamens.length,
                itemBuilder: (context, index) {
                  return _buildTestEtExamenTile(index);
                },
              ),
              TextButton(
                onPressed: _addTestEtExamen,
                child: const Text('Ajouter un Test/Examen'),
              ),
              const SizedBox(height: 20),
              const Text('Suivi des soins',
                  style: TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: suiviDesSoins.length,
                itemBuilder: (context, index) {
                  return _buildSuiviDesSoinsTile(index);
                },
              ),
              TextButton(
                onPressed: _addSuiviDesSoins,
                child: const Text('Ajouter un Suivi des Soins'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.indigo),
                  padding: WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                  textStyle: WidgetStatePropertyAll<TextStyle>(
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final dossierMedical = DossierMedical(
                      id: widget.existingRecord?.id ??
                          DateTime.now().toString(),
                      nom: nom,
                      prenom: prenom,
                      dateNaissance: dateNaissance,
                      sexe: sexe,
                      adresse: adresse,
                      numeroTelephone: numeroTelephone,
                      antecedentsFamiliaux: antecedentsFamiliaux,
                      antecedentsPersonnels: antecedentsPersonnels,
                      antecedentsChirurgicaux: antecedentsChirurgicaux,
                      consultations: consultations,
                      testsEtExamens: testsEtExamens,
                      suiviDesSoins: suiviDesSoins,
                    );
                    widget.onSubmit(dossierMedical);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Enregistrer',
                    style: TextStyle(color: Colors.white)),
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
          border: const OutlineInputBorder(),
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

  Widget _buildConsultationTile(int index) {
    return Column(
      children: [
        Text('Consultation ${index + 1}',
            style: const TextStyle(
                color: Colors.indigo, fontWeight: FontWeight.bold)),
        ListTile(
          title: Text(
              'Date: ${consultations[index].date.toLocal()}'.split(' ')[0]),
          trailing: const Icon(Icons.keyboard_arrow_down),
          onTap: () => _selectConsultationDate(context, index),
        ),
        _buildTextField('Motif', (value) => consultations[index].motif = value!,
            initialValue: consultations[index].motif),
        _buildTextField('Observations',
            (value) => consultations[index].observations = value!,
            initialValue: consultations[index].observations),
        _buildTextField(
            'Traitements', (value) => consultations[index].traitements = value!,
            initialValue: consultations[index].traitements),
        const Divider(),
      ],
    );
  }

  Widget _buildTestEtExamenTile(int index) {
    return Column(
      children: [
        Text('Test/Examen ${index + 1}',
            style: const TextStyle(
                color: Colors.indigo, fontWeight: FontWeight.bold)),
        _buildTextField('Type', (value) => testsEtExamens[index].type = value!,
            initialValue: testsEtExamens[index].type),
        _buildTextField(
            'Résultat', (value) => testsEtExamens[index].resultat = value!,
            initialValue: testsEtExamens[index].resultat),
        const Divider(),
      ],
    );
  }

  Widget _buildSuiviDesSoinsTile(int index) {
    return Column(
      children: [
        Text('Suivi des Soins ${index + 1}',
            style: const TextStyle(
                color: Colors.indigo, fontWeight: FontWeight.bold)),
        _buildTextField('Traitements en Cours',
            (value) => suiviDesSoins[index].traitementsEnCours = value!,
            initialValue: suiviDesSoins[index].traitementsEnCours),
        _buildTextField('Suivi des Prescriptions',
            (value) => suiviDesSoins[index].suiviDesPrescriptions = value!,
            initialValue: suiviDesSoins[index].suiviDesPrescriptions),
        _buildTextField('Notes sur l\'Évolution',
            (value) => suiviDesSoins[index].notesEvolution = value!,
            initialValue: suiviDesSoins[index].notesEvolution),
        const Divider(),
      ],
    );
  }

  Future<void> _selectConsultationDate(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: consultations[index].date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        consultations[index].date = pickedDate;
      });
    }
  }
}
