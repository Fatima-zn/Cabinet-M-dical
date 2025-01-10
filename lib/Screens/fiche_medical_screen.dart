import 'package:flutter/material.dart';
import 'package:cabinet_medical_v2/Models/fiche_medical_model.dart';
import 'package:cabinet_medical_v2/Models/fiche_medical_service.dart';
import 'package:cabinet_medical_v2/Screens/fiche_medical_form.dart';
import 'package:intl/intl.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  final MedicalRecordService _medicalRecordService = MedicalRecordService();

  @override
  void initState() {
    super.initState();
    _loadMedicalRecords();
  }

  Future<void> _loadMedicalRecords() async {
    await _medicalRecordService.loadFromFile();
    setState(() {});
  }

  void _showMedicalRecordForm({MedicalRecord? existingRecord}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalRecordForm(
          onSubmit: (record) async {
            if (existingRecord != null) {
              await _medicalRecordService.editMedicalRecord(
                  existingRecord.id, record);
            } else {
              await _medicalRecordService.addMedicalRecord(record);
            }
            setState(() {});
          },
          existingRecord: existingRecord,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer cette fiche médicale ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _medicalRecordService.deleteMedicalRecord(id);
      setState(() {});
    }
  }

  void _showMedicalRecordDetails(MedicalRecord record) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Détails de la Fiche Médicale'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nom: ${record.nom}'),
                Text('Prénom: ${record.prenom}'),
                Text('Date de Naissance: ${formatter.format(record.dateNaissance)}'),
                Text('Sexe: ${record.sexe}'),
                Text('Adresse: ${record.adresse}'),
                Text('Numéro de Téléphone: ${record.numeroTelephone}'),
                Text('Poids: ${record.poids} kg'),
                Text('Taille: ${record.taille} cm'),
                Text('Maladies Chroniques: ${record.maladiesChroniques}'),
                Text('Antécédents Chirurgicaux: ${record.antecedentsChirurgicaux}'),
                Text('Allergies: ${record.allergies}'),
                Text('Vaccinations: ${record.vaccinations}'),
                ...record.medicaments.map((m) => Text(
                    'Médicament: ${m.nom}, Posologie: ${m.posologie}, Fréquence: ${m.frequence}')),
                ...record.examens.map(
                    (e) => Text('Examen: ${e.type}, Résultat: ${e.resultat}')),
                Text('Notes et Observations: ${record.notesObservations}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.indigo)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Fiches Médicales', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        )),
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Icon(Icons.arrow_back_outlined, color: Colors.white)
          )
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _medicalRecordService.medicalRecords.length,
          itemBuilder: (context, index) {
            final record = _medicalRecordService.medicalRecords[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text('${record.nom} ${record.prenom}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                subtitle: Text('Date: ${formatter.format(DateTime.now())}', style: const TextStyle(color: Colors.black87)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                      onPressed: () {
                        _showMedicalRecordForm(existingRecord: record);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.indigo),
                      onPressed: () {
                        _confirmDelete(context, record.id);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  _showMedicalRecordDetails(record);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMedicalRecordForm();
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
