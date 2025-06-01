import 'package:equatable/equatable.dart';

class ScanResult extends Equatable {
  final String code;
  final DateTime timestamp;
  final ScanType type;

  const ScanResult({
    required this.code,
    required this.timestamp,
    required this.type,
  });

  @override
  List<Object> get props => [code, timestamp, type];

  @override
  String toString() {
    return 'ScanResult(code: $code, timestamp: $timestamp, type: $type)';
  }
}

enum ScanType { entrada, salida }