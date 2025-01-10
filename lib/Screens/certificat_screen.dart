import 'package:flutter/material.dart';
import 'package:cabinet_medical_v2/Models/certificat_model.dart';
import 'package:cabinet_medical_v2/Models/certificat_service.dart';
import 'package:cabinet_medical_v2/Models/mailer_service.dart';
import 'package:cabinet_medical_v2/Models/service_patient.dart';
import 'package:intl/intl.dart';
import 'certificat_form.dart';

class CertificatsScreen extends StatefulWidget {
  const CertificatsScreen({super.key});

  @override
  State<CertificatsScreen> createState() => _CertificatsScreenState();
}

class _CertificatsScreenState extends State<CertificatsScreen> {
  final CertificatService _certificatService = CertificatService();
  final PatientService _patientService = PatientService();
  final MailerService _mailerService = MailerService(
      username: 'cabinet_mail@gmail.com', password: 'admin_password');

  @override
  void initState() {
    super.initState();
    _loadCertificats();
  }

  Future<void> _loadCertificats() async {
    await _certificatService.loadFromFile();
    await _patientService.loadFromFile();
    setState(() {});
  }

  void _showCertificatForm({CertificatMedical? existingCertificat}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificatForm(
          onSubmit: (certificat) async {
            if (existingCertificat != null) {
              await _certificatService.editCertificat(
                  existingCertificat.id, certificat);
            } else {
              await _certificatService.addCertificat(certificat);
            }
            setState(() {});
          },
          existingCertificat: existingCertificat,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce certificat ?'),
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
      await _certificatService.deleteCertificat(id);
      setState(() {});
    }
  }

  Future<void> _sendCertificat(String certificatId) async {
    final certificat = _certificatService.findCertificatById(certificatId);
    if (certificat != null) {
      final patient = _patientService.findPatientById(certificat.patientId);
      if (patient != null) {
        await _mailerService.sendEmail(
          patient.email,
          'Certificat Médical',
          'Voici votre certificat médical.',
          [],
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Certificat envoyé à ${patient.email}')));
      }
    }
  }

  void _showCertificatDetails(CertificatMedical certificat) {
    showDialog(
      context: context,
      builder: (context) {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');

        return AlertDialog(
          title: const Text('Détails du Certificat Médical'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Type: ${certificat.type}'),
                Text('Nom: ${certificat.nom}'),
                Text('Prénom: ${certificat.prenom}'),
                Text('Âge: ${certificat.age}'),
                Text('Sexe: ${certificat.sexe}'),
                Text('Du: ${formatter.format(certificat.du)}'),
                Text('Au: ${formatter.format(certificat.au)}'),
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
        title: const Text('Gestion des Certificats Médicaux', style: TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _certificatService.certificats.length,
          itemBuilder: (context, index) {
            final certificat = _certificatService.certificats[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text('Certificat: ${certificat.nom} ${certificat.prenom}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                subtitle: Text('Date: ${formatter.format(DateTime.now())}', style: const TextStyle(color: Colors.black87)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.indigo),
                      onPressed: () {
                        _sendCertificat(certificat.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                      onPressed: () {
                        _showCertificatForm(existingCertificat: certificat);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.blueGrey),
                      onPressed: () {
                        _confirmDelete(context, certificat.id);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  _showCertificatDetails(certificat);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCertificatForm();
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
