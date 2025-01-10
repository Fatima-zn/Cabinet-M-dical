import 'package:cabinet_medical_v2/Screens/certificat_screen.dart';
import 'package:cabinet_medical_v2/Screens/dossier_medical_screen.dart';
import 'package:cabinet_medical_v2/Screens/fiche_medical_screen.dart';
import 'package:flutter/material.dart';




class MedicalDocumentCategoriesScreen extends StatelessWidget {
  const MedicalDocumentCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryTile(
              context,
              icon: Icons.folder,
              title: 'Dossiers Médicaux',
              screen: const DossierMedicalScreen(),
            ),
            _buildCategoryTile(
              context,
              icon: Icons.receipt,
              title: 'Certificats Médicaux',
              screen: const CertificatsScreen(),
            ),
            _buildCategoryTile(
              context,
              icon: Icons.insert_drive_file,
              title: 'Fiches Médicales',
              screen: const MedicalRecordScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, {required IconData icon, required String title, required Widget screen}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
