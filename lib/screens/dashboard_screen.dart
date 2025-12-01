import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart';
import 'diagnosis_form_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // --- Metode untuk membangun Grafik Diagnosa (Posisi Baru: Atas) ---
  Widget _buildDiagnosticGraphic(BuildContext context) {
    // Menggunakan Padding di bagian luar agar lebih terpisah dari AppBar
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 24.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status Cepat Lambung",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.shield_outlined, color: Colors.green, size: 28),
                ],
              ),
              const SizedBox(height: 10),
              
              // Elemen visual utama: Ilustrasi/Diagram
              Image.asset(
                'assets/images/image.png', // Menggunakan logo Anda sebagai ilustrasi
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.healing, size: 80, color: Colors.blueAccent);
                },
              ),
              
              const SizedBox(height: 15),
              
              Text(
                "Akurasi Sistem Pakar: 80% - 100%",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.greenAccent),
              ),
              const SizedBox(height: 4),
              Text(
                "Ditenagai oleh Certainty Factor (CF).",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Metode untuk membangun Header Selamat Datang (Dihapus) ---
  // Kode asli _buildWelcomeHeader dihapus atau diabaikan.
  
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 36, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Tentang Aplikasi"),
        content: const Text(
          "Aplikasi ini adalah Sistem Pakar Diagnosis Dini Penyakit Lambung (GERD & Gastritis) menggunakan Metode Certainty Factor (CF). \n\nLogika diagnosis didasarkan pada penelitian akademik terkait sistem pakar kesehatan yang terlampir.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Tutup", style: TextStyle(color: Colors.blueAccent))),
        ],
      ),
    );
  }
  
  void _showPreventionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Tips Pencegahan"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("1. Makanlah dalam porsi kecil namun sering."),
            Text("2. Hindari makanan pemicu (pedas, asam, berlemak)."),
            Text("3. Jangan langsung berbaring setelah makan (tunggu 2-3 jam)."),
            Text("4. Kelola stres dengan baik."),
            Text("5. Kurangi konsumsi kafein dan alkohol."),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Tutup", style: TextStyle(color: Colors.blueAccent))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDarkMode = themeManager.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        // Menghapus judul AppBar sesuai permintaan
        title: const Text("", style: TextStyle(fontSize: 20)), 
        actions: [
          // Tombol Theme Switch
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            tooltip: isDarkMode ? 'Ubah ke Light Mode' : 'Ubah ke Dark Mode',
            onPressed: () {
              themeManager.toggleTheme(!isDarkMode);
            },
          ),
        ],
      ),
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // 1. GRAFIK DIAGNOSA ESTETIK (Posisi Baru: Atas)
            _buildDiagnosticGraphic(context),
            
            // 2. Judul Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Pilih Menu Layanan",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),

            // 3. Grid Menu Tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.assignment,
                    title: "Mulai Diagnosa",
                    subtitle: "Isi data diri dan gejala untuk diagnosis.",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const DiagnosisFormScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.history,
                    title: "Riwayat",
                    subtitle: "Lihat hasil diagnosa yang pernah disimpan.",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.info_outline,
                    title: "Tentang Aplikasi",
                    subtitle: "Informasi metode dan sumber data.",
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.local_hospital_outlined,
                    title: "Pencegahan",
                    subtitle: "Tips menjaga kesehatan lambung.",
                    onTap: () {
                      _showPreventionDialog(context);
                    },
                  ),
                ],
              ),
            ),
            // Padding bawah agar tidak terlalu mepet
            const SizedBox(height: 30), 
          ],
        ),
      ),
    );
  }
}