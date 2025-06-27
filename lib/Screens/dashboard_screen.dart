import 'package:flutter/material.dart';
import 'inspection_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String name;
  final String role;
  final String token;

  const DashboardScreen({
    super.key,
    required this.name,
    required this.role,
    required this.token,
  });

  void _startInspection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InspectionFormScreen(name: name, token: token),
      ),
    );
  }

  void _viewReports(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("View Past Reports tapped")),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: "Logout",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("👋 Welcome $name", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text("🧑‍💼 Role: $role", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _startInspection(context),
              icon: const Icon(Icons.playlist_add_check),
              label: const Text("Start New Inspection"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _viewReports(context),
              icon: const Icon(Icons.history),
              label: const Text("View Past Reports"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
