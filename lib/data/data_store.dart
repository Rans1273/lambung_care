import '../models/models.dart';

class DataStore {
  // Pilihan keyakinan user (CF User) berdasarkan Tabel 1 Sumber 1 dan 2
  static List<UserChoice> choices = [
    UserChoice("Tidak", 0.0),
    UserChoice("Tidak Tahu", 0.2),
    UserChoice("Mungkin", 0.4),
    UserChoice("Kemungkinan Besar", 0.6),
    UserChoice("Hampir Pasti", 0.8),
    UserChoice("Pasti", 1.0),
  ];

  static List<Disease> diseases = [
    Disease(id: 'P01', name: 'Gastritis (Maag)', solution: 'Makan teratur, hindari makanan pedas dan asam, kelola stress.'),
    Disease(id: 'P02', name: 'GERD', solution: 'Jangan langsung tidur setelah makan, hindari kafein, dan makan dalam porsi kecil.'),
  ];

  static List<Symptom> symptoms = [
    Symptom(id: 'G01', name: 'Nyeri pada perut'),
    Symptom(id: 'G02', name: 'Mual'), 
    Symptom(id: 'G03', name: 'Muntah'), 
    Symptom(id: 'G05', name: 'Nyeri pada hulu hati'),
    Symptom(id: 'G14', name: 'Sensasi terbakar/panas pada dada (Heartburn)'),
    Symptom(id: 'G16', name: 'Gangguan tidur'),
    Symptom(id: 'G29', name: 'Asam lambung naik'),
  ];

  // Aturan & Bobot Pakar (CF Pakar) - Menggunakan contoh dari Tabel 4, Sumber 1
  static List<Rule> rules = [
    // Rules untuk Gastritis (P01)
    Rule(diseaseId: 'P01', symptomId: 'G01', expertWeight: 1.0),
    Rule(diseaseId: 'P01', symptomId: 'G02', expertWeight: 1.0), 
    Rule(diseaseId: 'P01', symptomId: 'G03', expertWeight: 1.0), 
    Rule(diseaseId: 'P01', symptomId: 'G05', expertWeight: 1.0),
    Rule(diseaseId: 'P01', symptomId: 'G16', expertWeight: 0.4), 
    
    // Rules untuk GERD (P02)
    Rule(diseaseId: 'P02', symptomId: 'G01', expertWeight: 1.0),
    Rule(diseaseId: 'P02', symptomId: 'G02', expertWeight: 0.4), 
    Rule(diseaseId: 'P02', symptomId: 'G03', expertWeight: 0.4), 
    Rule(diseaseId: 'P02', symptomId: 'G05', expertWeight: 1.0),
    Rule(diseaseId: 'P02', symptomId: 'G14', expertWeight: 1.0), // Gejala Kunci GERD
    Rule(diseaseId: 'P02', symptomId: 'G16', expertWeight: 0.8), 
    Rule(diseaseId: 'P02', symptomId: 'G29', expertWeight: 1.0),
  ];
}