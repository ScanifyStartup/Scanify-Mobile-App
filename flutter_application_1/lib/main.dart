import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Scanify",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Colors.deepPurple,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
