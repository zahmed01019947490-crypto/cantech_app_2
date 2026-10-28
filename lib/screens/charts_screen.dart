import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/obd_service.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final List<double> _rpmHistory = [2000, 2100, 2050, 2200, 2150, 2300, 2250, 2100, 2000, 2050];
  final List<double> _tempHistory = [88, 88.5, 89, 88.8, 89.2, 88.7, 89.0, 88.6, 88.5, 88.9];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<OBDDataModel>(
        stream: OBDService().telemetryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _rpmHistory.add(snapshot.data!.rpm);
            if (_rpmHistory.length > 10) _rpmHistory.removeAt(0);

            _tempHistory.add(snapshot.data!.coolantTemp);
            if (_tempHistory.length > 10) _tempHistory.removeAt(0);
          }

          final currentRpm = snapshot.data?.rpm ?? 2000.0;
          final currentTemp = snapshot.data?.coolantTemp ?? 88.0;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TELEMETRY REAL-TIME CHARTS',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const Text(
                  'ENGINE LIVE PERFORMANCE STREAM',
                  style: TextStyle(
                    color: AppColors.cyanNeon,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // RPM Chart Card
                _buildChartCard(
                  title: 'ENGINE RPM HISTORY',
                  value: '${currentRpm.toInt()} RPM',
                  color: AppColors.primaryBlue,
                  dataPoints: List.from(_rpmHistory),
                  minVal: 1000,
                  maxVal: 4000,
                ),
                const SizedBox(height: 18),

                // Coolant Temp Chart Card
                _buildChartCard(
                  title: 'COOLANT TEMP HISTORY',
                  value: '${currentTemp.toStringAsFixed(1)} °C',
                  color: currentTemp > 90 ? Colors.redAccent : AppColors.cyanNeon,
                  dataPoints: List.from(_tempHistory),
                  minVal: 70,
                  maxVal: 110,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String value,
    required Color color,
    required List<double> dataPoints,
    required double minVal,
    required double maxVal,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 90,
            child: CustomPaint(
              size: const Size(double.infinity, 90),
              painter: SimpleLineChartPainter(
                points: dataPoints,
                color: color,
                minVal: minVal,
                maxVal: maxVal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleLineChartPainter extends CustomPainter {
  final List<double> points;
  final Color color;
  final double minVal;
  final double maxVal;

  SimpleLineChartPainter({
    required this.points,
    required this.color,
    required this.minVal,
    required this.maxVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final double stepX = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      double normalizedY = (points[i] - minVal) / (maxVal - minVal);
      normalizedY = normalizedY.clamp(0.0, 1.0);
      double y = size.height - (normalizedY * size.height);
      double x = i * stepX;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
