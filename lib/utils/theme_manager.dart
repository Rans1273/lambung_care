import 'package:flutter/material.dart';

// Definisi warna shadow kustom
const Color darkShadow = Color.fromRGBO(0, 0, 0, 0.4); // Shadow gelap untuk mode terang
const Color lightShadow = Color.fromRGBO(52, 152, 219, 0.25); // Shadow biru muda untuk mode gelap

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; 

  get themeMode => _themeMode;

  toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// Definisikan tema Dark
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1E1E1E), 
  cardColor: const Color(0xFF2C2C2C), 
  // Tambahkan shadow color ke skema warna kustom (jika Anda menggunakan ekstensi tema, tapi di sini kita pakai Box Shadow)
  
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
    bodyLarge: TextStyle(color: Colors.white70), 
    bodyMedium: TextStyle(color: Colors.white54),
    titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600), // Tambahkan ini
    titleSmall: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent, 
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: const TextStyle(color: Colors.white70),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF2C2C2C),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    menuStyle: MenuStyle(
      backgroundColor: MaterialStateProperty.all(const Color(0xFF2C2C2C)),
    ),
  ),
  canvasColor: const Color(0xFF2C2C2C), 
);

// Definisikan tema Light
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
  textTheme: TextTheme(
    headlineSmall: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.grey[800]),
    bodyMedium: TextStyle(color: Colors.grey[600]),
    titleMedium: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w600),
    titleSmall: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: TextStyle(color: Colors.grey[800]),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[200],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    menuStyle: MenuStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white),
    ),
  ),
  canvasColor: Colors.white,
);