import 'package:flutter/material.dart';
import 'package:cabinet_medical_v2/Models/dossier_medical_model.dart';
import 'package:cabinet_medical_v2/Models/dossier_medical_service.dart';
import 'dossier_medical_form.dart';
import 'package:intl/intl.dart';




class DossierMedicalScreen extends StatefulWidget {
  const DossierMedicalScreen({super.key});

  @override
  State<DossierMedicalScreen> createState() => _DossierMedicalScreenState();
}

class _DossierMedicalScreenState extends State<DossierMedicalScreen> {
  final DossierMedicalService _dossierMedicalService = DossierMedicalService();
  final TextEditingController _searchController = TextEditingController();
  List<DossierMedical> _filteredDossiers = [];

  @override
  void initState() {
    super.initState();
    _loadDossiersMedical();
    _searchController.addListener(_filterDossiers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDossiers);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDossiersMedical() async {
    await _dossierMedicalService.loadFromFile();
    setState(() {
      _filteredDossiers = _dossierMedicalService.dossiersMedical;
    });
  }

  void _filterDossiers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDossiers = _dossierMedicalService.dossiersMedical.where((dossier) {
        return dossier.nom.toLowerCase().contains(query) ||
               dossier.prenom.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showDossierMedicalForm({DossierMedical? existingRecord}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DossierMedicalForm(
          onSubmit: (record) async {
            if (existingRecord != null) {
              await _dossierMedicalService.editDossierMedical(existingRecord.id, record);
            } else {
              await _dossierMedicalService.addDossierMedical(record);
            }
            setState(() {
              _filteredDossiers = _dossierMedicalService.dossiersMedical;
            });
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
        content: const Text('Êtes-vous sûr de vouloir supprimer ce dossier médical ?'),
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
      await _dossierMedicalService.deleteDossierMedical(id);
      setState(() {
        _filteredDossiers = _dossierMedicalService.dossiersMedical;
      });
    }
  }

  void _showDossierMedicalDetails(DossierMedical dossier) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Détails du Dossier Médical'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nom: ${dossier.nom}'),
                Text('Prénom: ${dossier.prenom}'),
                Text('Date de Naissance: ${formatter.format(dossier.dateNaissance)}'),
                Text('Sexe: ${dossier.sexe}'),
                Text('Adresse: ${dossier.adresse}'),
                Text('Numéro de Téléphone: ${dossier.numeroTelephone}'),
                Text('Antécédents Familiaux: ${dossier.antecedentsFamiliaux}'),
                Text('Antécédents Personnels: ${dossier.antecedentsPersonnels}'),
                Text('Antécédents Chirurgicaux: ${dossier.antecedentsChirurgicaux}'),
                ...dossier.consultations.map((c) => Text(
                  'Consultation le ${formatter.format(c.date)}: ${c.motif}, ${c.observations}, Traitements: ${c.traitements}')),
                ...dossier.testsEtExamens.map((te) => Text('Test/Examen: ${te.type}, Résultat: ${te.resultat}')),
                ...dossier.suiviDesSoins.map((ss) => Text(
                  'Suivi des Soins: Traitements en Cours: ${ss.traitementsEnCours}, Suivi des Prescriptions: ${ss.suiviDesPrescriptions}, Notes sur l\'Évolution: ${ss.notesEvolution}')),
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
        title: const Text('Gestion des Dossiers Médicaux', style: TextStyle(
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
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _filteredDossiers.length,
                itemBuilder: (context, index) {
                  final dossier = _filteredDossiers[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text('${dossier.nom} ${dossier.prenom}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      subtitle: Text('Date: ${formatter.format(DateTime.now())}', style: const TextStyle(color: Colors.black87)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.deepOrange),
                            onPressed: () {
                              _showDossierMedicalForm(existingRecord: dossier);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.indigo),
                            onPressed: () {
                              _confirmDelete(context, dossier.id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _showDossierMedicalDetails(dossier);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDossierMedicalForm();
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
