import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart'; 

class HistoryService {
  static const _keyHistory = 'diagnosis_history';

  // Menyimpan riwayat baru (TIDAK BERUBAH)
  Future<void> saveHistory(DiagnosisHistory newHistory) async {
    final prefs = await SharedPreferences.getInstance();
    List<DiagnosisHistory> currentHistory = await getHistory(isReversed: false);

    // Tambahkan riwayat baru ke daftar
    currentHistory.add(newHistory);
    
    // Konversi daftar objek menjadi List<String> JSON
    final List<String> jsonList = currentHistory.map((h) => jsonEncode(h.toJson())).toList();
    
    await prefs.setStringList(_keyHistory, jsonList);
  }

  // Mengambil semua riwayat (TIDAK BERUBAH)
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

    return isReversed ? history.reversed.toList() : history;
  }

  // --- FUNGSI BARU (DIBUTUHKAN): Menghapus satu item riwayat berdasarkan ID ---
  Future<void> deleteHistoryItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<DiagnosisHistory> currentHistory = await getHistory(isReversed: false);

    // Filter list: simpan semua yang ID-nya TIDAK sama dengan ID yang dihapus
    currentHistory.removeWhere((h) => h.id == id);

    // Konversi daftar objek yang dimodifikasi menjadi List<String> JSON dan simpan
    final List<String> jsonList = currentHistory.map((h) => jsonEncode(h.toJson())).toList();
    
    await prefs.setStringList(_keyHistory, jsonList);
  }

  // --- FUNGSI BARU (DIBUTUHKAN): Menghapus semua riwayat ---
  Future<void> deleteAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }
}