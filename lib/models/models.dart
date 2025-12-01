import 'dart:convert'; // Diperlukan untuk jsonEncode/jsonDecode di HistoryService

// 1. Model Penyakit
class Disease {
  final String id;
  final String name;
  final String solution;

  Disease({required this.id, required this.name, required this.solution});
}

// 2. Model Gejala
class Symptom {
  final String id;
  final String name;

  Symptom({required this.id, required this.name});
}

// 3. Model Aturan (Menghubungkan Penyakit dan Gejala)
class Rule {
  final String diseaseId;
  final String symptomId;
  final double expertWeight; // CF Pakar (Certainty Factor Pakar)

  Rule({required this.diseaseId, required this.symptomId, required this.expertWeight});
}

// 4. Model Pilihan Pengguna
class UserChoice {
  final String label;
  final double value; // CF User (Certainty Factor User)

  UserChoice(this.label, this.value);
}

// 5. Model Riwayat Diagnosa (Untuk penyimpanan lokal menggunakan JSON)
class DiagnosisHistory {
  final String id; // ID unik untuk setiap riwayat
  final String name;
  final String gender;
  final int age;
  final DateTime date;
  final String primaryDiagnosis;
  final double certaintyPercentage;
  final String solution;
  // Menyimpan semua hasil diagnosa (semua penyakit dan persentasenya)
  final List<Map<String, dynamic>> allResults;

  DiagnosisHistory({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.date,
    required this.primaryDiagnosis,
    required this.certaintyPercentage,
    required this.solution,
    required this.allResults,
  });

  // Factory Constructor untuk membuat objek dari JSON (saat memuat dari SharedPreferences)
  factory DiagnosisHistory.fromJson(Map<String, dynamic> json) {
    return DiagnosisHistory(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      age: json['age'],
      // Mengubah string ISO 8601 menjadi objek DateTime
      date: DateTime.parse(json['date']),
      primaryDiagnosis: json['primaryDiagnosis'],
      certaintyPercentage: json['certaintyPercentage'],
      solution: json['solution'],
      // Memastikan allResults dikonversi dengan benar
      allResults: List<Map<String, dynamic>>.from(json['allResults']),
    );
  }

  // Metode untuk mengubah objek menjadi JSON (saat menyimpan ke SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'age': age,
      // Mengubah DateTime menjadi string ISO 8601
      'date': date.toIso8601String(),
      'primaryDiagnosis': primaryDiagnosis,
      'certaintyPercentage': certaintyPercentage,
      'solution': solution,
      'allResults': allResults,
    };
  }
}