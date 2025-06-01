import 'package:flutter/services.dart';
import '../models/scan_result.dart';

class ScannerProvider {
  Future<void> playSuccessSound() async {
    try {
      // Reproduce un sonido de sistema usando HapticFeedback
      await SystemSound.play(SystemSoundType.click);
      // Además, añade vibración para confirmar
      await HapticFeedback.lightImpact();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  ScanResult createScanResult(String code, ScanType type) {
    return ScanResult(
      code: code,
      timestamp: DateTime.now(),
      type: type,
    );
  }

  void dispose() {
    // No hay recursos que liberar en esta versión
  }
}
