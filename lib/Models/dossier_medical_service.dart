import 'dart:convert';
import 'dart:io';
import 'dossier_medical_model.dart';



class DossierMedicalService {
  List<DossierMedical> _dossiersMedical = [];

  List<DossierMedical> get dossiersMedical => _dossiersMedical;

  Future<void> addDossierMedical(DossierMedical dossierMedical) async {
    _dossiersMedical.add(dossierMedical);
    await _saveToFile();
  }

  Future<void> editDossierMedical(String id, DossierMedical updatedDossierMedical) async {
    int index = _dossiersMedical.indexWhere((dossier) => dossier.id == id);
    if (index != -1) {
      _dossiersMedical[index] = updatedDossierMedical;
      await _saveToFile();
    }
  }

  Future<void> deleteDossierMedical(String id) async {
    _dossiersMedical.removeWhere((dossier) => dossier.id == id);
    await _saveToFile();
  }


  Future<void> loadFromFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/dossiers_medical.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      final jsonData = jsonDecode(data) as List;
      _dossiersMedical = jsonData.map((json) => DossierMedical.fromJson(json)).toList();
    }
  }

  Future<void> _saveToFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/dossiers_medical.json');
    final jsonData = _dossiersMedical.map((dossier) => dossier.toJson()).toList();
    
    
    await file.writeAsString(jsonEncode(jsonData));
  }
}
