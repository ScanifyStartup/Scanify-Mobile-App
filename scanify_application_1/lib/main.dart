import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen.dart';
import 'blocs/scanner_bloc.dart';
import 'repositories/scanner_repository.dart';
import 'providers/scanner_provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner QR/Barcode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => ScannerBloc(
          repository: ScannerRepository(
            provider: ScannerProvider(),
          ),
        ),
        child: HomeScreen(),
      ),
    );
  }
}
