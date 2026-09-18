import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integrity Ledger - Citizen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primaryColor: const Color(0xFF1E3A5F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A5F),
          primary: const Color(0xFF1E3A5F),
          secondary: const Color(0xFF10151F),
          surface: const Color(0xFFF8F9FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF10151F),
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Color(0xFF10151F)),
          titleTextStyle: TextStyle(
            color: Color(0xFF10151F), 
            fontSize: 20, 
            fontWeight: FontWeight.w500
          ),
          shape: Border(bottom: BorderSide(color: Color(0xFFD8DCE2), width: 1)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A5F),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.5),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1E3A5F),
            side: const BorderSide(color: Color(0xFF1E3A5F)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFD8DCE2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFFD8DCE2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Color(0xFF1E3A5F)),
          ),
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF5B6472), letterSpacing: 1.5),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFD8DCE2),
          thickness: 1,
          space: 32,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF10151F)),
          bodyMedium: TextStyle(color: Color(0xFF5B6472)),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Ideally replace with a good sans-serif like Inter if available
      ),
      home: const LoginScreen(),
    );
  }
}
