import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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
  String infrastructureRating = '', cleanlinessRating = '', teacherPresenceRating = '';
  File? capturedImage;
  Position? currentPosition;
  bool isSubmitting = false;

  // 🔁 Replace ObjectIds with real ones from your MongoDB
  final Map<String, String> schoolMap = {
    "Greenfield Academy": "684fc46a465a6fd70c17232b",
    "Symbiosis Institute of Technology": "684fc497465a6fd70c17232d",
  };

  final schoolList = ["Greenfield Academy", "Symbiosis Institute of Technology"];
  final ratingOptions = ["Excellent", "Good", "Average", "Poor"];

  Future<void> _captureImageAndLocation() async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked == null) return;
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        capturedImage = File(picked.path);
        currentPosition = pos;
      });
    } catch (e) {
      _showSnack("Capture failed: $e");
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (capturedImage == null || currentPosition == null) {
      _showSnack("Please capture photo and location");
      return;
    }
    if (!schoolMap.containsKey(selectedSchool)) {
      _showSnack("Invalid school selected");
      return;
    }

    _formKey.currentState!.save();
    setState(() => isSubmitting = true);

    try {
      final uri = Uri.parse("http://10.0.2.2:5050/api/inspection/submit");
      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer ${widget.token}'
        ..fields['school'] = schoolMap[selectedSchool]!
        ..fields['ratings[infrastructure]'] = infrastructureRating
        ..fields['ratings[cleanliness]'] = cleanlinessRating
        ..fields['ratings[teacherPresence]'] = teacherPresenceRating
        ..fields['location[lat]'] = currentPosition!.latitude.toString()
        ..fields['location[lng]'] = currentPosition!.longitude.toString()
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          capturedImage!.path,
          filename: path.basename(capturedImage!.path),
        ));

      final resp = await req.send();
      final body = await http.Response.fromStream(resp);

      if (resp.statusCode == 200) {
        _showSnack("Inspection submitted ✅");
        Navigator.pop(context);
      } else {
        _showSnack("Submission failed: ${body.body}");
      }
    } catch (e) {
      _showSnack("Error: $e");
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  DropdownButtonFormField<String> _ratingDropdown(String label, String? val, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: val,
      hint: Text(label),
      items: ratingOptions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select $label" : null,
    );
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
              DropdownButtonFormField(
                value: selectedSchool,
                hint: const Text("Select School"),
                items: schoolList.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => selectedSchool = v),
                validator: (v) => v == null ? "Please select a school" : null,
              ),
              const SizedBox(height: 16),
              _ratingDropdown("Infrastructure Rating",
                  infrastructureRating.isNotEmpty ? infrastructureRating : null,
                      (v) => setState(() => infrastructureRating = v!)),
              const SizedBox(height: 16),
              _ratingDropdown("Cleanliness Rating",
                  cleanlinessRating.isNotEmpty ? cleanlinessRating : null,
                      (v) => setState(() => cleanlinessRating = v!)),
              const SizedBox(height: 16),
              _ratingDropdown("Teacher Presence",
                  teacherPresenceRating.isNotEmpty ? teacherPresenceRating : null,
                      (v) => setState(() => teacherPresenceRating = v!)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture Photo + Location"),
                onPressed: isSubmitting ? null : _captureImageAndLocation,
              ),
              if (capturedImage != null) ...[
                const SizedBox(height: 16),
                Image.file(capturedImage!, height: 200),
              ],
              if (currentPosition != null) ...[
                const SizedBox(height: 8),
                Text(
                  "Location: (${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)})",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
              const SizedBox(height: 24),
              isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: submitForm,
                child: const Text("Submit Inspection"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
