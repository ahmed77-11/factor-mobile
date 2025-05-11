import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:factor_mobile_app/entities/Utilisateur.dart';
import 'package:factor_mobile_app/service/authService.dart';

class AuthProvider with ChangeNotifier {
  Utilisateur? _user;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;
  final AuthService _authService = AuthService();

  Utilisateur? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        _user = Utilisateur.fromJson(userJson);
      }
    } catch (e) {
      print('Error initializing user: $e');
      await _clearUserData();
    }
  }

  Future<void> login(String email, String password) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _safeNotify();

    try {
      final userData = await _authService.loginMobile(email, password);
      _user = Utilisateur.fromJson(userData);
      await _saveUserData(userData);
    } catch (e) {
      _user = null;
      _error = e.toString();
      await _clearUserData();
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> changePassword(
    String code,
    String newPassword,
    String confirmPassword,
    String token,
  ) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _safeNotify();

    try {
      await _authService.changePasswordFirstTime(
        code,
        newPassword,
        confirmPassword,
        token,
      );
      final updatedUser =
          await _authService.loginMobile(_user!.email, newPassword);
      _user = Utilisateur.fromJson(updatedUser);
      await _saveUserData(updatedUser);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> sendEmailVerfication(String email) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _safeNotify();
    try {
      await _authService.sendEmailVerfication(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> verifierCode(String email, String code) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _safeNotify();
    try {
      await _authService.verifCode(email, code);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> resetPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _safeNotify();
    try {
      await _authService.resetPassword(
        email,
        password,
        confirmPassword,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> updateUserProfile(
      {required String firstName,
      required String lastName,
      required String email,
      File? profileImage,
      String? token}) async {
    _isLoading = true;
    _error = null;
    _safeNotify();

    try {
      String? imagePath;

      if (profileImage != null) {
        final uploadResult =
            await _authService.uploadProfileImage(profileImage, token);
        imagePath = uploadResult['fileName']; // Use only the filename
      }

      final response = await _authService.updateMobileUser(
        firstname: firstName,
        lastname: lastName,
        email: email,
        profilePicture: imagePath,
        token: token,
      );

      _user = Utilisateur.fromJson(response);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(response));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> logout() async {
    if (_isLoading) return;

    _isLoading = true;
    _safeNotify();

    try {
      await _authService.logout();
      _user = null;
      await _clearUserData();
    } catch (e) {
      print(e.toString());
      _error = e.toString();
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(userData));
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }
}
