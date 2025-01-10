import 'package:flutter/material.dart';
import 'package:cabinet_medical_v2/Models/patient_model.dart';

class PatientForm extends StatefulWidget {
  final Function(Patient) onSubmit;
  final Patient? existingPatient;

  const PatientForm({super.key, required this.onSubmit, this.existingPatient});

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  late String id;
  late String firstName;
  late String lastName;
  late String age;
  late String gender;
  late String phoneNumber;
  late String email;

  @override
  void initState() {
    super.initState();
    id = widget.existingPatient?.id ?? DateTime.now().toString();
    firstName = widget.existingPatient?.firstName ?? '';
    lastName = widget.existingPatient?.lastName ?? '';
    age = widget.existingPatient?.age ?? '';
    gender = widget.existingPatient?.gender ?? '';
    phoneNumber = widget.existingPatient?.phoneNumber ?? '';
    email = widget.existingPatient?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Patient', style: TextStyle(
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
                _buildTextField('Age', initialValue: age, onSaved: (value) => age = value!),
                _buildTextField('Genre', initialValue: gender, onSaved: (value) => gender = value!),
                _buildTextField('Téléphone', initialValue: phoneNumber, onSaved: (value) => phoneNumber = value!),
                _buildTextField('Email', initialValue: email, onSaved: (value) => email = value!),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:WidgetStatePropertyAll<Color>(Colors.indigo),
                    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                    textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final patient = Patient(
                        id: id,
                        firstName: firstName,
                        lastName: lastName,
                        age: age,
                        gender: gender,
                        phoneNumber: phoneNumber,
                        email: email,
                        allergies: [],
                        medicalHistory: [],
                      );
                      widget.onSubmit(patient);
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
