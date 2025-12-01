import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/data_store.dart';
import '../logic/expert_system_logic.dart';
import '../models/models.dart';
import '../services/history_service.dart';

class DiagnosisFormScreen extends StatefulWidget {
  const DiagnosisFormScreen({super.key});

  @override
  State<DiagnosisFormScreen> createState() => _DiagnosisFormScreenState();
}

class _DiagnosisFormScreenState extends State<DiagnosisFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _gender;
  DateTime? _dateOfBirth;

  Map<String, double> userAnswers = {};

  @override
  void initState() {
    super.initState();
    for (var symptom in DataStore.symptoms) {
      userAnswers[symptom.id] = 0.0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // --- Fungsi Perhitungan Usia ---
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
  
  // --- Fungsi Pilih Tanggal ---
  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  // --- Fungsi Submit Diagnosa ---
  void _submitDiagnosis() {
    if (_formKey.currentState!.validate()) {
      if (_gender == null || _dateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap lengkapi Jenis Kelamin dan Tanggal Lahir.')),
        );
        return;
      }

      // 1. Hitung Usia
      final age = _calculateAge(_dateOfBirth!);

      // 2. Lakukan Perhitungan CF
      var results = ExpertSystemLogic.calculate(userAnswers);
      final topResult = results.first;

      // 3. Siapkan Data Riwayat (untuk disimpan)
      final history = DiagnosisHistory(
        id: const Uuid().v4(),
        name: _nameController.text,
        gender: _gender!,
        age: age,
        date: DateTime.now(),
        primaryDiagnosis: topResult.disease.name,
        certaintyPercentage: topResult.percentage,
        solution: topResult.disease.solution,
        allResults: results.map((r) => {'name': r.disease.name, 'percentage': r.percentage}).toList(),
      );
      
      // 4. Simpan Riwayat
      HistoryService().saveHistory(history);

      // 5. Tampilkan Hasil
      _showResultDialog(results, age);
    }
  }

  // --- Widget Build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Diagnosa")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // --- Bagian Input Profil Pengguna ---
                  Text("Data Diri Pasien", style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(),
                  _buildProfileInputCard(context),
                  const SizedBox(height: 30),

                  // --- Bagian Input Gejala (CF) ---
                  Text("Gejala yang Dialami", style: Theme.of(context).textTheme.headlineSmall),
                  Text("Tentukan tingkat keyakinan Anda terhadap setiap gejala.", style: Theme.of(context).textTheme.bodyMedium),
                  const Divider(),
                  ...DataStore.symptoms.map((symptom) => _buildSymptomCard(context, symptom)).toList(),
                ],
              ),
            ),
            // Tombol Diagnosa
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitDiagnosis,
                  child: const Text(
                    "Proses Diagnosa (Certainty Factor)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // --- Widget Input Profil ---
  Widget _buildProfileInputCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              value: _gender,
              items: ['Laki-laki', 'Perempuan'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _gender = newValue;
                });
              },
              validator: (value) {
                if (value == null) return 'Pilih jenis kelamin';
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_dateOfBirth == null
                  ? 'Tanggal Lahir (Usia: -)'
                  : 'Tanggal Lahir: ${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year} (Usia: ${_calculateAge(_dateOfBirth!)} tahun)'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDateOfBirth(context),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Input Gejala ---
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
              hint: const Text("Pilih tingkat keyakinan"),
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
  
  // --- Dialog Hasil ---
  void _showResultDialog(List<DiagnosisResult> results, int age) {
    final topResult = results.first;
    // ... (Logika dialog hasil sama seperti sebelumnya, tapi sekarang menggunakan data usia dan nama)
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Hasil Diagnosa (${topResult.percentage.toStringAsFixed(1)}%)"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pasien: ${_nameController.text} (${age} th)"),
              const Divider(height: 16),
              Text(
                "Diagnosa Utama:",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                topResult.disease.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              Text("Saran Penanganan:", style: Theme.of(context).textTheme.titleSmall),
              Text(topResult.disease.solution, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              Text(
                "Semua Hasil:",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
              ...results.map((e) => Text(
                "- ${e.disease.name}: ${e.percentage.toStringAsFixed(1)}%",
                style: Theme.of(context).textTheme.bodySmall,
              )),
            ],
          ),
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