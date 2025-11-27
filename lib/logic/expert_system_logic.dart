import '../models/models.dart';
import '../data/data_store.dart';

class DiagnosisResult {
  final Disease disease;
  final double percentage;

  DiagnosisResult(this.disease, this.percentage);
}

class ExpertSystemLogic {
  // Input: Map<SymptomID, CFUserValue>
  static List<DiagnosisResult> calculate(Map<String, double> userInputs) {
    List<DiagnosisResult> results = [];

    // 1. Iterasi setiap penyakit
    for (var disease in DataStore.diseases) {
      double cfCombine = 0.0;
      bool isFirstSymptom = true;

      // Ambil rules yang relevan untuk penyakit ini
      var relevantRules = DataStore.rules.where((r) => r.diseaseId == disease.id).toList();

      for (var rule in relevantRules) {
        // Cek apakah user memilih gejala ini dan CF-nya > 0 (bukan 'Tidak')
        if (userInputs.containsKey(rule.symptomId) && userInputs[rule.symptomId]! > 0.0) {
          double cfUser = userInputs[rule.symptomId]!;
          double cfPakar = rule.expertWeight;

          // Rumus 1: CF Gejala = CF User * CF Pakar
          double cfGejala = cfUser * cfPakar;

          // Rumus 2: CF Combine (Iteratif): CFold + CFnew * (1 - CFold)
          if (isFirstSymptom) {
            cfCombine = cfGejala;
            isFirstSymptom = false;
          } else {
            cfCombine = cfCombine + cfGejala * (1 - cfCombine);
          }
        }
      }

      // Simpan hasil (dikali 100 untuk persentase)
      results.add(DiagnosisResult(disease, cfCombine * 100));
    }

    // Urutkan dari persentase tertinggi
    results.sort((a, b) => b.percentage.compareTo(a.percentage));
    return results;
  }
}