import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Key _futureKey = UniqueKey();
  final HistoryService _historyService = HistoryService();

  bool _isMultiSelectMode = false;
  final Set<String> _selectedItems = {};

  // --- FIX 1: Menambahkan if (mounted) ---
  void _deleteItem(String id) async {
    await _historyService.deleteHistoryItem(id);
    
    if (!mounted) return; // Mencegah penggunaan context setelah widget dibuang

    if (_isMultiSelectMode) {
      _selectedItems.remove(id);
      if (_selectedItems.isEmpty) {
        _isMultiSelectMode = false;
      }
    }
    
    setState(() {
      _futureKey = UniqueKey();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Riwayat berhasil dihapus.')),
    );
  }

  // --- FIX 1: Menambahkan if (mounted) ---
  void _deleteAll() async {
    await _historyService.deleteAllHistory();
    
    if (!mounted) return; // Mencegah penggunaan context setelah widget dibuang

    setState(() {
      _futureKey = UniqueKey();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua riwayat berhasil dihapus.')),
    );
  }

  // --- FIX 1: Menambahkan if (mounted) ---
  void _deleteSelectedItems() async {
    if (_selectedItems.isEmpty) return;

    for (var id in _selectedItems) {
      await _historyService.deleteHistoryItem(id);
    }
    
    if (!mounted) return; // Mencegah penggunaan context setelah widget dibuang
    
    setState(() {
      final count = _selectedItems.length;
      _selectedItems.clear();
      _isMultiSelectMode = false;
      _futureKey = UniqueKey();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$count riwayat berhasil dihapus.')),
      );
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
        if (_selectedItems.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedItems.add(id);
        _isMultiSelectMode = true;
      }
    });
  }

  // --- Dialog Konfirmasi Hapus Item Tunggal (dipanggil dari Dialog Detail) ---
  void _confirmDeleteFromDetail(BuildContext context, String id) {
    Navigator.of(context).pop(); // Tutup dialog detail
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Anda yakin ingin menghapus item riwayat ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteItem(id); // Hapus item dan refresh tampilan
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- Dialog Konfirmasi Hapus Semua ---
  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Konfirmasi Hapus Semua"),
        content: const Text("Anda yakin ingin menghapus SEMUA riwayat diagnosa yang tersimpan? Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteAll();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus Semua", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  // --- Dialog Detail Riwayat (Diubah untuk tombol Hapus) ---
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
          // Tombol HAPUS di dalam Dialog Detail
          TextButton(
            onPressed: () => _confirmDeleteFromDetail(context, history.id),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
          // Tombol Tutup
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Tutup", style: TextStyle(color: Colors.blueAccent))),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Conditional AppBar Title
        title: _isMultiSelectMode 
          ? Text("${_selectedItems.length} Terpilih")
          : const Text("Riwayat Diagnosa"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        
        // Tombol Close/Back
        leading: _isMultiSelectMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isMultiSelectMode = false;
                  _selectedItems.clear();
                });
              },
            )
          : null,
          
        actions: [
          if (_isMultiSelectMode)
            // Tombol Hapus Multi-Select
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: Colors.redAccent,
              onPressed: _selectedItems.isEmpty ? null : _deleteSelectedItems,
            )
          else 
            // Tombol Hapus Semua
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
              tooltip: 'Hapus Semua Riwayat',
              onPressed: () => _confirmDeleteAll(context),
            ),
        ],
      ),
      body: FutureBuilder<List<DiagnosisHistory>>(
        key: _futureKey,
        future: _historyService.getHistory(),
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
              final isSelected = _selectedItems.contains(history.id);

              // Warna seleksi (dibuat eksplisit untuk menghindari warning deprecated)
              final selectedColor = Color.fromRGBO(66, 165, 245, 0.2); 
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: isSelected ? selectedColor : Theme.of(context).cardColor,
                child: ListTile(
                  // Aksi TAP: Memulai atau melanjutkan seleksi
                  onTap: () {
                    if (_isMultiSelectMode) {
                      _toggleSelection(history.id);
                    } else {
                      _showHistoryDetail(context, history);
                    }
                  },
                  // Aksi LONG PRESS: Memulai mode multi-select
                  onLongPress: () {
                    if (!_isMultiSelectMode) {
                      _toggleSelection(history.id);
                    } else {
                      _toggleSelection(history.id);
                    }
                  },
                  
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? Colors.blue : Colors.blueAccent,
                    child: isSelected 
                      ? const Icon(Icons.check, color: Colors.white) 
                      : Text(history.age.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  
                  title: Text(
                    history.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  
                  subtitle: Text(
                    "Hasil: ${history.primaryDiagnosis} (${history.certaintyPercentage.toStringAsFixed(1)}%) - ${history.date.day}/${history.date.month}/${history.date.year}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  
                  // Trailing (Checkbox saat Multi-Select, atau Arrow saat normal)
                  trailing: _isMultiSelectMode 
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (val) => _toggleSelection(history.id),
                        activeColor: Colors.blue,
                      )
                    : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}