import '../models/scan_result.dart';
import '../providers/scanner_provider.dart';

class ScannerRepository {
  final ScannerProvider provider;

  ScannerRepository({required this.provider});

  Future<ScanResult> processScan(String code, ScanType type) async {
    // Reproduce el sonido de éxito
    await provider.playSuccessSound();
    
    // Crea el resultado del escaneo
    return provider.createScanResult(code, type);
  }

  void dispose() {
    provider.dispose();
  }
}