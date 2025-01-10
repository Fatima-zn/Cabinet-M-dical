import 'package:flutter/material.dart';
import 'package:cabinet_medical_v2/Models/certificat_model.dart';
import 'package:cabinet_medical_v2/Models/patient_model.dart';
import 'package:cabinet_medical_v2/Models/service_patient.dart';
import 'package:intl/intl.dart';

class CertificatForm extends StatefulWidget {
  final Function(CertificatMedical) onSubmit;
  final CertificatMedical? existingCertificat;

  const CertificatForm({super.key, required this.onSubmit, this.existingCertificat});

  @override
  State<CertificatForm> createState() => _CertificatFormState();
}

class _CertificatFormState extends State<CertificatForm> {
  final _formKey = GlobalKey<FormState>();
  late String id;
  late String type;
  late String nom;
  late String prenom;
  late int age;
  late String sexe;
  late DateTime du;
  late DateTime au;
  late String patientId;
  final PatientService _patientService = PatientService();

  @override
  void initState() {
    super.initState();
    id = widget.existingCertificat?.id ?? DateTime.now().toString();
    type = widget.existingCertificat?.type ?? '';
    nom = widget.existingCertificat?.nom ?? '';
    prenom = widget.existingCertificat?.prenom ?? '';
    age = widget.existingCertificat?.age ?? 0;
    sexe = widget.existingCertificat?.sexe ?? '';
    du = widget.existingCertificat?.du ?? DateTime.now();
    au = widget.existingCertificat?.au ?? DateTime.now();
    patientId = widget.existingCertificat?.patientId ?? '';
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    await _patientService.loadFromFile();
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context, bool isDu) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isDu ? du : au,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isDu) {
          du = pickedDate;
        } else {
          au = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificat Médical', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        )),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
                width: 60,
                height: 60,
                child: Icon(Icons.arrow_back_outlined, color: Colors.white))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: patientId.isNotEmpty ? patientId : null,
                  hint: const Text('Sélectionnez un patient'),
                  items: _patientService.patients.map((Patient patient) {
                    return DropdownMenuItem<String>(
                      value: patient.id,
                      child: Text('${patient.firstName} ${patient.lastName}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      patientId = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un patient';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Patient',
                    labelStyle: const TextStyle(color: Colors.indigo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextFormField('Type', initialValue: type, onSaved: (value) => type = value!),
                const SizedBox(height: 20),
                _buildTextFormField('Nom', initialValue: nom, onSaved: (value) => nom = value!),
                const SizedBox(height: 20),
                _buildTextFormField('Prénom', initialValue: prenom, onSaved: (value) => prenom = value!),
                const SizedBox(height: 20),
                _buildTextFormField('Âge', initialValue: age.toString(), keyboardType: TextInputType.number, onSaved: (value) => age = int.parse(value!)),
                const SizedBox(height: 20),
                _buildTextFormField('Sexe', initialValue: sexe, onSaved: (value) => sexe = value!),
                const SizedBox(height: 20),
                ListTile(
                  title: Text('Du: ${formatter.format(du)}'),
                  trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.indigo),
                  onTap: () => _selectDate(context, true),
                ),
                ListTile(
                  title: Text('Au: ${formatter.format(au)}'),
                  trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.indigo),
                  onTap: () => _selectDate(context, false),
                ),
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
                      final certificat = CertificatMedical(
                        id: id,
                        type: type,
                        nom: nom,
                        prenom: prenom,
                        age: age,
                        sexe: sexe,
                        du: du,
                        au: au,
                        patientId: patientId,
                      );
                      widget.onSubmit(certificat);
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

  Widget _buildTextFormField(String labelText, {required String initialValue, TextInputType keyboardType = TextInputType.text, required FormFieldSetter<String> onSaved}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.indigo),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
      ),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $labelText';
        }
        return null;
      },
    );
  }
}
