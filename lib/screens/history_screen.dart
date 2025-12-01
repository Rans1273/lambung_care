import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Diagnosa"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: FutureBuilder<List<DiagnosisHistory>>(
        future: HistoryService().getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Belum ada riwayat diagnosa tersimpan.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          final historyList = snapshot.data!;
          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final history = historyList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      history.age.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    history.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Hasil: ${history.primaryDiagnosis} (${history.certaintyPercentage.toStringAsFixed(1)}%) - ${history.date.day}/${history.date.month}/${history.date.year}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () => _showHistoryDetail(context, history),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  void _showHistoryDetail(BuildContext context, DiagnosisHistory history) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Detail Riwayat"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nama: ${history.name}"),
              Text("Usia/JK: ${history.age} tahun / ${history.gender}"),
              const Divider(),
              Text(
                "Diagnosa Utama:",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.blueAccent),
              ),
              Text(
                history.primaryDiagnosis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text("Keyakinan: ${history.certaintyPercentage.toStringAsFixed(1)}%"),
              const Divider(),
              const Text("Semua Hasil:", style: TextStyle(fontWeight: FontWeight.bold)),
              ...history.allResults.map((result) => Text("${result['name']}: ${result['percentage'].toStringAsFixed(1)}%",
                 style: Theme.of(context).textTheme.bodySmall,
              )),
              const Divider(),
              Text("Saran Penanganan: ${history.solution}", style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Tutup", style: TextStyle(color: Colors.blueAccent))),
        ],
      ),
    );
  }
}