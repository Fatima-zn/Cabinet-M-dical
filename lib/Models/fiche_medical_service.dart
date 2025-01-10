import 'dart:convert';
import 'dart:io';

import 'package:cabinet_medical_v2/Models/fiche_medical_model.dart';



class MedicalRecordService {
  List<MedicalRecord> _medicalRecords = [];

  List<MedicalRecord> get medicalRecords => _medicalRecords;

  Future<void> addMedicalRecord(MedicalRecord medicalRecord) async {
    _medicalRecords.add(medicalRecord);
    await _saveToFile();
  }

  Future<void> editMedicalRecord(String id, MedicalRecord updatedMedicalRecord) async {
    int index = _medicalRecords.indexWhere((record) => record.id == id);
    if (index != -1) {
      _medicalRecords[index] = updatedMedicalRecord;
      await _saveToFile();
    }
  }

  Future<void> deleteMedicalRecord(String id) async {
    _medicalRecords.removeWhere((record) => record.id == id);
    await _saveToFile();
  }


  Future<void> loadFromFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/medical_records.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      final jsonData = jsonDecode(data) as List;
      _medicalRecords = jsonData.map((json) => MedicalRecord.fromJson(json)).toList();
    }
  }

  Future<void> _saveToFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/medical_records.json');
    final jsonData = _medicalRecords.map((record) => record.toJson()).toList();
    
    
    await file.writeAsString(jsonEncode(jsonData));
  }
}
