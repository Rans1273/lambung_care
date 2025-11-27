import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/get_started_screen.dart';
import 'utils/theme_manager.dart';

void main() {
  runApp(
    // Menggunakan Provider untuk Theme Management
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistem Pakar Lambung',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      home: const GetStartedScreen(), // Halaman awal
    );
  }
}