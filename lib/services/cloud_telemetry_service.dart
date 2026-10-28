import 'dart:async';
import 'auth_service.dart';

class CloudTelemetryService {
  static final CloudTelemetryService _instance = CloudTelemetryService._internal();
  factory CloudTelemetryService() => _instance;
  CloudTelemetryService._internal();

  final _telemetryLogController = StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get telemetryLogsStream => _telemetryLogController.stream;

  final List<Map<String, dynamic>> _cloudDatabase = [];

  // إرسال البيانات من ESP32 إلى السحابة مع معرّف العميل/السيارة
  void pushTelemetryToCloud({
    required double rpm,
    required double temp,
    required double speed,
    required List<Map<String, String>> dtcList,
  }) {
    final currentUser = AuthService().currentUser;

    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'clientId': currentUser?.uid ?? 'GUEST-00',
      'clientName': currentUser?.name ?? 'Unknown Client',
      'vehicleVin': currentUser?.vehicleVin ?? 'ESP32-GENERIC',
      'rpm': rpm,
      'coolantTemp': temp,
      'speed': speed,
      'activeDtcCount': dtcList.length,
      'dtcList': dtcList,
    };

    _cloudDatabase.insert(0, entry);
    if (_cloudDatabase.length > 20) _cloudDatabase.removeLast();

    _telemetryLogController.add(List.from(_cloudDatabase));
  }
}