import 'package:cabinet_medical_v2/Models/dossier_medical_model.dart';
import 'package:cabinet_medical_v2/Models/dossier_medical_service.dart';
import 'package:cabinet_medical_v2/Models/rendez_vous_model.dart';
import 'package:cabinet_medical_v2/Models/rendez_vous_service.dart';
import 'package:cabinet_medical_v2/Models/service_patient.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PatientService _patientService = PatientService();
  final AppointmentService _appointmentService = AppointmentService();
  final DossierMedicalService _dossierMedicalService = DossierMedicalService();

  int totalPatients = 0;
  int totalAppointments = 0;
  List<Appointment> upcomingAppointments = [];
  List<Appointment> recentAppointments = [];
  List<DossierMedical> dossiersMedical = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _patientService.loadFromFile();
    await _appointmentService.loadFromFile();
    await _dossierMedicalService.loadFromFile();

    setState(() {
      totalPatients = _patientService.patients.length;
      totalAppointments = _appointmentService.appointments.length;
      upcomingAppointments = _appointmentService.appointments
          .where((appointment) => appointment.date.isAfter(DateTime.now()))
          .toList();
      recentAppointments = _appointmentService.appointments
          .where((appointment) => appointment.date.isBefore(DateTime.now()))
          .toList();
      dossiersMedical = _dossierMedicalService.dossiersMedical;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDashboardCard('Total Patients', totalPatients.toString(),
                  Icons.person, Colors.blue),
              _buildDashboardCard(
                  'Total Appointments',
                  totalAppointments.toString(),
                  Icons.event_available,
                  Colors.green),
              _buildDashboardCard(
                  'Upcoming Appointments',
                  upcomingAppointments.length.toString(),
                  Icons.calendar_today,
                  Colors.red),
              _buildDashboardCard(
                  'Recent Appointments',
                  recentAppointments.length.toString(),
                  Icons.history,
                  Colors.orange),
              _buildDashboardCard(
                  'Dossiers Médicaux',
                  dossiersMedical.length.toString(),
                  Icons.folder,
                  Colors.purple),
              const SizedBox(height: 20),
              const Text('Upcoming Appointments',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              ...upcomingAppointments
                  .map((appointment) => _buildAppointmentTile(appointment)),
              const SizedBox(height: 20),
              const Text('Recent Appointments',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              ...recentAppointments
                  .map((appointment) => _buildAppointmentTile(appointment)),
            ],
          ),
        ),
    );
  }

  Widget _buildDashboardCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(value,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentTile(Appointment appointment) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text('Patient: ${appointment.firstName} ${appointment.lastName}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            'Date: ${formatter.format(appointment.date)} | Reason: ${appointment.reason}',
            style: const TextStyle(fontSize: 16)),
        leading: const Icon(Icons.event, color: Colors.indigo),
      ),
    );
  }
}
