import 'package:flutter/material.dart';
import 'package:cabinet_medical_v2/Models/rendez_vous_model.dart';
import 'package:cabinet_medical_v2/Models/rendez_vous_service.dart';
import 'package:cabinet_medical_v2/Screens/rendez_vous_form.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  final List<String> _filters = [
    'Today', 'Next Day', 'Soon', 'Next Week', 'Next Month', 'Morning', 'Afternoon', 'Done', 'No Show'
  ];
  final List<String> _selectedFilters = [];
  List<Appointment> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    await _appointmentService.loadFromFile();
    setState(() {
      _filteredAppointments = _appointmentService.appointments;
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
      _filterAppointments();
    });
  }

  void _filterAppointments() {
    final now = DateTime.now();
    setState(() {
      _filteredAppointments = _appointmentService.appointments.where((appointment) {
        bool matches = true;
        for (String filter in _selectedFilters) {
          if (filter == 'Today') {
            matches &= appointment.date.year == now.year &&
                      appointment.date.month == now.month &&
                      appointment.date.day == now.day;
          } else if (filter == 'Next Day') {
            matches &= appointment.date.isAfter(now) &&
                      appointment.date.isBefore(now.add(const Duration(days: 1)));
          } else if (filter == 'Soon') {
            matches &= appointment.date.isAfter(now) &&
                      appointment.date.isBefore(now.add(const Duration(days: 3)));
          } else if (filter == 'Next Week') {
            matches &= appointment.date.isAfter(now) &&
                      appointment.date.isBefore(now.add(const Duration(days: 7)));
          } else if (filter == 'Next Month') {
            matches &= appointment.date.isAfter(now) &&
                      appointment.date.isBefore(now.add(const Duration(days: 30)));
          } else if (filter == 'Morning') {
            matches &= appointment.date.hour >= 6 && appointment.date.hour < 12;
          } else if (filter == 'Afternoon') {
            matches &= appointment.date.hour >= 12 && appointment.date.hour < 18;
          } else if (filter == 'Done') {
            matches &= appointment.isDone;
          } else if (filter == 'No Show') {
            matches &= appointment.isNoShow;
          }
        }
        return matches;
      }).toList();
    });
  }

  void _toggleAppointmentDone(Appointment appointment) async {
    appointment.isDone = !appointment.isDone;
    await _appointmentService.editAppointment(appointment.id, appointment);
    _filterAppointments();
  }

  void _toggleAppointmentNoShow(Appointment appointment) async {
    appointment.isNoShow = !appointment.isNoShow;
    await _appointmentService.editAppointment(appointment.id, appointment);
    _filterAppointments();
  }

  void _showAppointmentForm({Appointment? existingAppointment}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentForm(
          onSubmit: (appointment) async {
            if (existingAppointment != null) {
              await _appointmentService.editAppointment(existingAppointment.id, appointment);
            } else {
              await _appointmentService.addAppointment(appointment);
            }
            setState(() {
              _filteredAppointments = _appointmentService.appointments;
            });
          },
          existingAppointment: existingAppointment,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce rendez-vous ?'),
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
      await _appointmentService.deleteAppointment(id);
      setState(() {
        _filteredAppointments = _appointmentService.appointments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Rendez-vous', style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final bool isSelected = _selectedFilters.contains(filter);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        _toggleFilter(filter);
                      },
                      selectedColor: Colors.indigo.shade50,
                      backgroundColor: Colors.grey.shade300,
                      labelStyle: TextStyle(color: isSelected ? Colors.indigo : Colors.black54, fontWeight: isSelected? FontWeight.w500 : FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: isSelected ? Colors.indigo : Colors.grey.shade300, width: 1.5),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black45,
                      checkmarkColor: Colors.indigo,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = _filteredAppointments[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text('${appointment.firstName} ${appointment.lastName}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      subtitle: Text('Date: ${formatter.format(appointment.date)} | Raison: ${appointment.reason}', style: const TextStyle(color: Colors.black87)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.done, color: appointment.isDone ? Colors.green : Colors.grey),
                            onPressed: () {
                              _toggleAppointmentDone(appointment);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.not_interested, color: appointment.isNoShow ? Colors.red : Colors.grey),
                            onPressed: () {
                              _toggleAppointmentNoShow(appointment);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.deepOrange),
                            onPressed: () {
                              _showAppointmentForm(existingAppointment: appointment);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.blueGrey),
                            onPressed: () {
                              _confirmDelete(context, appointment.id);
                            },
                          ),
                        ],
                      ),
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
          _showAppointmentForm();
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
