import 'dart:async';
import 'dart:math';

class OBDDataModel {
  final double rpm;
  final double coolantTemp;
  final double speed;
  final double throttlePosition;
  final List<Map<String, String>> activeDtcCodes;

  OBDDataModel({
    required this.rpm,
    required this.coolantTemp,
    required this.speed,
    required this.throttlePosition,
    required this.activeDtcCodes,
  });
}

class OBDService {
  static final OBDService _instance = OBDService._internal();
  factory OBDService() => _instance;
  OBDService._internal();

  Timer? _timer;
  final _controller = StreamController<OBDDataModel>.broadcast();

  Stream<OBDDataModel> get telemetryStream => _controller.stream;

  void startLiveStream() {
    _timer?.cancel();

    final random = Random();
    
    // تحديث كل 1.5 ثانية لتخفيف استهلاك المعالج والمحاكي
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      double simulatedRpm = 1800 + random.nextInt(1000).toDouble();
      double simulatedCoolant = 88.0 + random.nextDouble() * 3.0;
      double simulatedSpeed = 60.0 + random.nextInt(30).toDouble();
      double simulatedThrottle = 15.0 + random.nextDouble() * 15.0;

      _controller.add(
        OBDDataModel(
          rpm: simulatedRpm,
          coolantTemp: simulatedCoolant,
          speed: simulatedSpeed,
          throttlePosition: simulatedThrottle,
          activeDtcCodes: [],
        ),
      );
    });
  }

  void stopStream() {
    _timer?.cancel();
  }
}