import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/scanner_repository.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final ScannerRepository repository;

  ScannerBloc({required this.repository}) : super(ScannerInitial()) {
    on<ScanCode>(_onScanCode);
    on<ResetScanner>(_onResetScanner);
  }

  Future<void> _onScanCode(ScanCode event, Emitter<ScannerState> emit) async {
    try {
      emit(ScannerLoading());
      
      final result = await repository.processScan(event.code, event.type);
      
      emit(ScannerSuccess(result));
    } catch (e) {
      emit(ScannerError('Error al procesar el código: ${e.toString()}'));
    }
  }

  void _onResetScanner(ResetScanner event, Emitter<ScannerState> emit) {
    emit(ScannerInitial());
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}