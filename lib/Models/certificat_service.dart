import 'dart:convert';
import 'dart:io';
import 'certificat_model.dart';

class CertificatService {
  List<CertificatMedical> _certificats = [];

  List<CertificatMedical> get certificats => _certificats;

  Future<void> addCertificat(CertificatMedical certificat) async {
    _certificats.add(certificat);
    await _saveToFile();
  }

  Future<void> editCertificat(
      String id, CertificatMedical updatedCertificat) async {
    int index = _certificats.indexWhere((certificat) => certificat.id == id);
    if (index != -1) {
      _certificats[index] = updatedCertificat;
      await _saveToFile();
    }
  }

  Future<void> deleteCertificat(String id) async {
    _certificats.removeWhere((certificat) => certificat.id == id);
    await _saveToFile();
  }

  CertificatMedical? findCertificatById(String id) {
    try {
      return _certificats.firstWhere((certificat) => certificat.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadFromFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/certificats.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      final jsonData = jsonDecode(data) as List;
      _certificats =
          jsonData.map((json) => CertificatMedical.fromJson(json)).toList();
    }
  }

  Future<void> _saveToFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/certificats.json');
    final jsonData =
        _certificats.map((certificat) => certificat.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }
}
