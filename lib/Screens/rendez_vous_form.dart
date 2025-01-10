import 'package:flutter/material.dart';
import 'package:cabinet_medical_v2/Models/rendez_vous_model.dart';
import 'package:intl/intl.dart';

class AppointmentForm extends StatefulWidget {
  final Function(Appointment) onSubmit;
  final Appointment? existingAppointment;

  const AppointmentForm({super.key, required this.onSubmit, this.existingAppointment});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late DateTime date;
  late String reason;
  late bool isDone;
  late bool isNoShow;
  late TimeOfDay time;

  @override
  void initState() {
    super.initState();
    date = widget.existingAppointment?.date ?? DateTime.now();
    time = TimeOfDay.fromDateTime(date);
    if (widget.existingAppointment != null) {
      firstName = widget.existingAppointment!.firstName;
      lastName = widget.existingAppointment!.lastName;
      reason = widget.existingAppointment!.reason;
      isDone = widget.existingAppointment!.isDone;
      isNoShow = widget.existingAppointment!.isNoShow;
    } else {
      firstName = '';
      lastName = '';
      reason = '';
      isDone = false;
      isNoShow = false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, date.hour, date.minute);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (pickedTime != null) {
      setState(() {
        time = pickedTime;
        date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingAppointment == null ? 'Ajouter un Rendez-vous' : 'Modifier le Rendez-vous', style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        )),
        backgroundColor: Colors.indigo,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField('Prénom', initialValue: firstName, onSaved: (value) => firstName = value!),
                _buildTextField('Nom', initialValue: lastName, onSaved: (value) => lastName = value!),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('Date: ${formatter.format(date)}'),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: () => _selectDate(context),
                ),
                ListTile(
                  title: Text('Heure: ${time.format(context)}'),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: () => _selectTime(context),
                ),
                const SizedBox(height: 10),
                _buildTextField('Raison', initialValue: reason, onSaved: (value) => reason = value!),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigo,
                      value: isDone,
                      onChanged: (bool? value) {
                        setState(() {
                          isDone = value!;
                        });
                      },
                    ),
                    const Text('Rendez-vous terminé'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.indigo,
                      value: isNoShow,
                      onChanged: (bool? value) {
                        setState(() {
                          isNoShow = value!;
                        });
                      },
                    ),
                    const Text('Le patient n\'est pas venu'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.indigo),
                    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                    textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final appointment = Appointment(
                        id: widget.existingAppointment?.id ?? DateTime.now().toString(),
                        firstName: firstName,
                        lastName: lastName,
                        date: date,
                        reason: reason,
                        isDone: isDone,
                        isNoShow: isNoShow,
                      );
                      widget.onSubmit(appointment);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, {required String initialValue, required FormFieldSetter<String> onSaved}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.indigo),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.indigo),
          ),
        ),
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $labelText';
          }
          return null;
        },
      ),
    );
  }
}
