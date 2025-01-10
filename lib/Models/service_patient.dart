import 'dart:convert';
import 'dart:io';
import 'patient_model.dart';

class PatientService {
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  Future<void> addPatient(Patient patient) async {
    _patients.add(patient);
    await _saveToFile();
  }

  Future<void> editPatient(String id, Patient updatedPatient) async {
    int index = _patients.indexWhere((patient) => patient.id == id);
    if (index != -1) {
      _patients[index] = updatedPatient;
      await _saveToFile();
    }
  }

  Future<void> deletePatient(String id) async {
    _patients.removeWhere((patient) => patient.id == id);
    await _saveToFile();
  }



  Patient? findPatientById(String id) {
    try {
      return _patients.firstWhere((patient) => patient.id == id);
    } catch (e) {
      return null;
    }
  }


  Future<void> loadFromFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/patients.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      final jsonData = jsonDecode(data) as List;
      _patients = jsonData.map((json) => Patient.fromJson(json)).toList();
    }
  }

  Future<void> _saveToFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/patients.json');
    final jsonData = _patients.map((patient) => patient.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }
}
