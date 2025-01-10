import 'package:cabinet_medical_v2/Models/patient_model.dart';
import 'package:cabinet_medical_v2/Models/service_patient.dart';
import 'package:cabinet_medical_v2/Screens/patient_form.dart';
import 'package:flutter/material.dart';



class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final PatientService _patientService = PatientService();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    await _patientService.loadFromFile();
    setState(() {});
  }

  void _showPatientForm({Patient? existingPatient}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientForm(
          onSubmit: (patient) async{
            if (existingPatient != null) {
              await _patientService.editPatient(existingPatient.id, patient);
            } else{
              await _patientService.addPatient(patient);
            }
            setState(() {});
          },
          existingPatient: existingPatient,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce patient ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Annuler', style: TextStyle(color: Colors.indigo)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.indigo)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _patientService.deletePatient(id);
      setState(() {});
    }
  }

  void _showPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Détails du Patient'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nom: ${patient.firstName} ${patient.lastName}'),
                Text('Age: ${patient.age}'),
                Text('Sexe: ${patient.gender}'),
                Text('Numéro de Téléphone: ${patient.phoneNumber}'),
                Text('Email: ${patient.email}'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Patients', style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _patientService.patients.length,
          itemBuilder: (context, index) {
            final patient = _patientService.patients[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text('${patient.firstName} ${patient.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${patient.phoneNumber}'),
                    Text('Email: ${patient.email}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.teal),
                      onPressed: () {
                        _showPatientDetails(patient);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                      onPressed: () {
                        _showPatientForm(existingPatient: patient);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.blueGrey),
                      onPressed: () {
                        _confirmDelete(context, patient.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPatientForm();
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
