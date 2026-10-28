import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/auth_service.dart';
import '../services/cloud_telemetry_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isBluetoothConnected = true;
  bool _isCloudSyncActive = true;

  void _handleLogout() {
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SETTINGS & CLOUD CONFIG',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      'USER: ${user?.name ?? "ENG AHMED MOHAMED"} (${user?.role.name.toUpperCase() ?? "ENGINEER"})',
                      style: const TextStyle(
                        color: AppColors.cyanNeon,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
                  tooltip: 'Logout',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hardware Connection Node Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bluetooth_connected, color: AppColors.cyanNeon, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESP32 HARDWARE NODE',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          'VIN Linked: ${user?.vehicleVin ?? "ESP32-NODE-01"}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isBluetoothConnected,
                    activeColor: AppColors.cyanNeon,
                    onChanged: (val) {
                      setState(() {
                        _isBluetoothConnected = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cloud Telemetry Live Log
            Container(
              padding: const EdgeInsets.all(16),
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
                      Row(
                        children: const [
                          Icon(Icons.cloud_done_outlined, color: Colors.greenAccent, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'CLOUD SYNC STATUS',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isCloudSyncActive,
                        activeColor: Colors.greenAccent,
                        onChanged: (val) {
                          setState(() {
                            _isCloudSyncActive = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.cardBorder, height: 20),

                  const Text(
                    'LIVE CLOUD DATABASE LOGS',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: CloudTelemetryService().telemetryLogsStream,
                    builder: (context, snapshot) {
                      final logs = snapshot.data ?? [];

                      if (logs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Awaiting cloud telemetry packets...',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                        );
                      }

                      return Column(
                        children: logs.take(3).map((log) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${log['clientName']} (${log['vehicleVin']})',
                                      style: const TextStyle(color: AppColors.cyanNeon, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'RPM: ${log['rpm']} | Temp: ${(log['coolantTemp'] as double).toStringAsFixed(1)}°C',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Developer Signature Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
              ),
              child: Column(
                children: const [
                  Text(
                    'CAN-TECH SYSTEM V1.0.0',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'DESIGNED & DEVELOPED BY ENG AHMED MOHAMED',
                    style: TextStyle(color: AppColors.cyanNeon, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
