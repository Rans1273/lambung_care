import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart'; 

class HistoryService {
  static const _keyHistory = 'diagnosis_history';

  // Menyimpan riwayat baru
  Future<void> saveHistory(DiagnosisHistory newHistory) async {
    final prefs = await SharedPreferences.getInstance();
    List<DiagnosisHistory> currentHistory = await getHistory(isReversed: false);

    // Tambahkan riwayat baru ke daftar
    currentHistory.add(newHistory);
    
    // Konversi daftar objek menjadi List<String> JSON
    final List<String> jsonList = currentHistory.map((h) => jsonEncode(h.toJson())).toList();
    
    await prefs.setStringList(_keyHistory, jsonList);
  }

  // Mengambil semua riwayat
  Future<List<DiagnosisHistory>> getHistory({bool isReversed = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_keyHistory);
    
    if (jsonList == null) {
      return [];
    }

    // Konversi List<String> JSON kembali ke List<DiagnosisHistory>
    List<DiagnosisHistory> history = jsonList.map((jsonString) {
      try {
        return DiagnosisHistory.fromJson(jsonDecode(jsonString));
      } catch (e) {
        // Abaikan data yang rusak
        return null;
      }
    }).whereType<DiagnosisHistory>().toList();

    return isReversed ? history.reversed.toList() : history; // Tampilkan yang terbaru di atas jika isReversed=true
  }
}