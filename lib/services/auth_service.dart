import 'dart:async';

enum UserRole { engineer, client }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String? vehicleVin;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.vehicleVin,
  });
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // قاعدة بيانات الحسابات - حسابك الشخصي كأدمن معتمد هنا
  final Map<String, Map<String, String>> _registeredUsers = {
    'zahmed01019947490@gmail.com': {
      'password': 'ZAHMED1232033',
      'name': 'Eng Ahmed Mohamed',
      'role': 'engineer',
      'vin': 'CAN-TECH-ADMIN-01',
    },
  };

  // تسجيل الدخول مع التحقق الفعلي من الإيميل والباسورد
  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final cleanEmail = email.trim().toLowerCase();

    // التحقق هل الإيميل متسجل والباسورد مطابق تماماً؟
    if (_registeredUsers.containsKey(cleanEmail)) {
      final userData = _registeredUsers[cleanEmail]!;
      if (userData['password'] == password) {
        _currentUser = UserModel(
          uid: cleanEmail == 'zahmed01019947490@gmail.com' ? 'ENG-001' : 'USR-${DateTime.now().millisecondsSinceEpoch}',
          name: userData['name']!,
          email: cleanEmail,
          role: userData['role'] == 'engineer' ? UserRole.engineer : UserRole.client,
          vehicleVin: userData['vin'],
        );
        return true; // نجاح التسجيل
      }
    }

    return false; // رفض الدخول (بيانات خاطئة)
  }

  // تسجيل حساب عميل جديد
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String espDeviceId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final cleanEmail = email.trim().toLowerCase();

    _registeredUsers[cleanEmail] = {
      'password': password,
      'name': name,
      'role': 'client',
      'vin': 'ESP-$espDeviceId',
    };

    _currentUser = UserModel(
      uid: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: cleanEmail,
      role: UserRole.client,
      vehicleVin: 'ESP-$espDeviceId',
    );
    return true;
  }

  void logout() {
    _currentUser = null;
  }
}