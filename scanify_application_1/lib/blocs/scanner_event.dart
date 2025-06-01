import 'package:equatable/equatable.dart';
import '../models/scan_result.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object> get props => [];
}

class ScanCode extends ScannerEvent {
  final String code;
  final ScanType type;

  const ScanCode(this.code, this.type);

  @override
  List<Object> get props => [code, type];
}

class ResetScanner extends ScannerEvent {}