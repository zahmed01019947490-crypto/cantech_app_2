import 'package:flutter/material.dart';

class VehicleData {
  final double rpm;
  final double coolantTemp;
  final double speed;
  final double throttlePosition;
  final bool hasError;

  VehicleData({
    required this.rpm,
    required this.coolantTemp,
    required this.speed,
    required this.throttlePosition,
    this.hasError = false,
  });
}

class VehicleDataProvider extends ChangeNotifier {
  VehicleData _vehicleData = VehicleData(
    rpm: 2450.0,
    coolantTemp: 88.5,
    speed: 65.0,
    throttlePosition: 18.2,
    hasError: false,
  );

  VehicleData get vehicleData => _vehicleData;

  void updateData({
    double? rpm,
    double? coolantTemp,
    double? speed,
    double? throttlePosition,
    bool? hasError,
  }) {
    _vehicleData = VehicleData(
      rpm: rpm ?? _vehicleData.rpm,
      coolantTemp: coolantTemp ?? _vehicleData.coolantTemp,
      speed: speed ?? _vehicleData.speed,
      throttlePosition: throttlePosition ?? _vehicleData.throttlePosition,
      hasError: hasError ?? _vehicleData.hasError,
    );
    notifyListeners();
  }
}