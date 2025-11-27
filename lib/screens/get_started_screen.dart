import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dashboard_screen.dart'; // Mengarah ke DashboardScreen

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi video
    _controller = VideoPlayerController.asset('assets/Videos/click_pakar.mp4') 
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0.0);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video Player
          if (_isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              ),
            ),

          // Overlay Gelap
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Konten Get Started
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sistem Pakar\nDiagnosis Dini Penyakit Lambung",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontSize: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Dapatkan diagnosa awal yang cepat dan akurat untuk gejala GERD dan Gastritis menggunakan metode Certainty Factor (CF).",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const DashboardScreen()),
                        );
                      },
                      child: const Text(
                        "Mulai Diagnosa",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}