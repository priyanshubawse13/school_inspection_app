import 'package:flutter/material.dart';

class InspectionFormScreen extends StatefulWidget {
  final String token;
  final String name;

  const InspectionFormScreen({
    super.key,
    required this.token,
    required this.name,
  });

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedSchool;
  String infrastructure = '';
  String cleanliness = '';
  String teacherPresence = '';

  final List<String> schoolList = [
    "Sunrise Public School",
    "Greenfield Academy",
    "Mount Carmel High",
  ];

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // For now, print to console
      print("Inspector: ${widget.name}");
      print("Token: ${widget.token}");
      print("School: $selectedSchool");
      print("Infrastructure: $infrastructure");
      print("Cleanliness: $cleanliness");
      print("Teacher Presence: $teacherPresence");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inspection Submitted")),
      );

      Navigator.pop(context); // Go back to Dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Inspection")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedSchool,
                hint: const Text("Select School"),
                items: schoolList.map((school) {
                  return DropdownMenuItem(value: school, child: Text(school));
                }).toList(),
                onChanged: (value) => setState(() => selectedSchool = value),
                validator: (value) =>
                value == null ? "Please select a school" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Infrastructure Review"),
                onSaved: (val) => infrastructure = val ?? '',
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Cleanliness Review"),
                onSaved: (val) => cleanliness = val ?? '',
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Teacher Presence Review"),
                onSaved: (val) => teacherPresence = val ?? '',
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Submit Inspection"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
