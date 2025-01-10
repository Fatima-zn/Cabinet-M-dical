import 'package:cabinet_medical_v2/Screens/categories_screen.dart';
import 'package:cabinet_medical_v2/Screens/dashboard_screen.dart';
import 'package:cabinet_medical_v2/Screens/patient_screen.dart';
import 'package:cabinet_medical_v2/Screens/rendez_vous_screen.dart';
import 'package:cabinet_medical_v2/Widgets/app_bar.dart';
import 'package:cabinet_medical_v2/Widgets/list_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cabinet Médical'),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                'Cabinet Médical',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Tile(icon: Icons.dashboard, title: "Tableau de Bord", onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
            }),
            Tile(
                icon: Icons.person,
                title: "Gestion des Patients",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientsScreen()));
                }),
            Tile(
                icon: Icons.calendar_today,
                title: "Gestion des Rendez-vous",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppointmentsScreen()));
                }),
            Tile(
                icon: Icons.folder,
                title: "Gestion des Dossiers",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MedicalDocumentCategoriesScreen()));
                }),
            //Tile(icon: Icons.login, title: "Login/Logout", onTap: () {})
          ],
        ),
      ),
      body: const DashboardScreen()
    );
  }
}
