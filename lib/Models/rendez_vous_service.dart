import 'dart:convert';
import 'dart:io';
import 'rendez_vous_model.dart';

class AppointmentService {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  Future<void> addAppointment(Appointment appointment) async {
    _appointments.add(appointment);
    await _saveToFile();
  }

  Future<void> editAppointment(
      String id, Appointment updatedAppointment) async {
    int index = _appointments.indexWhere((appointment) => appointment.id == id);
    if (index != -1) {
      _appointments[index] = updatedAppointment;
      await _saveToFile();
    }
  }

  Future<void> deleteAppointment(String id) async {
    _appointments.removeWhere((appointment) => appointment.id == id);
    await _saveToFile();
  }

  Future<void> loadFromFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/appointments.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      final jsonData = jsonDecode(data) as List;
      _appointments =
          jsonData.map((json) => Appointment.fromJson(json)).toList();
    }
  }

  Future<void> _saveToFile() async {
    const directory = "C:\\Users\\esthr\\OneDrive\\Desktop\\cabinet_medical_v2\\Data";
    final file = File('$directory/appointments.json');
    final jsonData =
        _appointments.map((appointment) => appointment.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }
}
