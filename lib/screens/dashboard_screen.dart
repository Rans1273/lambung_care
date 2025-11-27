import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../data/data_store.dart';
import '../logic/expert_system_logic.dart';
import '../utils/theme_manager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, double> userAnswers = {};

  @override
  void initState() {
    super.initState();
    // Inisialisasi jawaban default ke 'Tidak' (0.0)
    for (var symptom in DataStore.symptoms) {
      userAnswers[symptom.id] = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Akses ThemeManager dan status dark mode
    final themeManager = Provider.of<ThemeManager>(context);
    final isDarkMode = themeManager.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sistem Pakar Lambung", style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            tooltip: isDarkMode ? 'Ubah ke Light Mode' : 'Ubah ke Dark Mode',
            onPressed: () {
              themeManager.toggleTheme(!isDarkMode);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, Pengguna!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  "Pilih tingkat keyakinan Anda terhadap gejala yang dialami.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                _buildInfoCard(context),
              ],
            ),
          ),
          // Daftar Gejala
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: DataStore.symptoms.length,
              itemBuilder: (context, index) {
                final symptom = DataStore.symptoms[index];
                return _buildSymptomCard(context, symptom);
              },
            ),
          ),
          // Tombol Diagnosa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  var results = ExpertSystemLogic.calculate(userAnswers);
                  _showResultDialog(results);
                },
                child: const Text(
                  "Dapatkan Diagnosa",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.calculate, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Metode Certainty Factor", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    "Sistem akan menghitung persentase keyakinan (CF) Anda.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomCard(BuildContext context, Symptom symptom) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              symptom.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Menggunakan DropdownButtonFormField untuk input CF User
            DropdownButtonFormField<double>(
              value: userAnswers[symptom.id],
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              hint: Text("Pilih tingkat keyakinan", style: Theme.of(context).textTheme.bodyMedium),
              items: DataStore.choices.map((UserChoice choice) {
                return DropdownMenuItem<double>(
                  value: choice.value,
                  child: Text(choice.label, style: Theme.of(context).textTheme.bodyMedium),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    userAnswers[symptom.id] = value;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDialog(List<DiagnosisResult> results) {
    final topResult = results.first;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Hasil Diagnosa", style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Penyakit: ${topResult.disease.name}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueAccent),
            ),
            const SizedBox(height: 8),
            Text(
              "Tingkat Keyakinan: ${topResult.percentage.toStringAsFixed(2)}%",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 24),
            Text("Saran Penanganan:", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              topResult.disease.solution,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (results.length > 1) ...[
              const SizedBox(height: 20),
              Text(
                "Kemungkinan Lain:",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
              ...results.skip(1).map((e) => Text(
                "- ${e.disease.name}: ${e.percentage.toStringAsFixed(2)}%",
                style: Theme.of(context).textTheme.bodySmall,
              )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Tutup", style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
    );
  }
}