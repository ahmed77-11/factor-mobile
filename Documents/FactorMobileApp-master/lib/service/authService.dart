import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:8082/factoring/users/api";

  Future<Map<String, dynamic>> loginMobile(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/loginMobile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data));
      return data;
    } else {
      throw Exception('Échec de la connexion');
    }
  }

  Future<void> changePasswordFirstTime(
    String code,
    String newPassword,
    String confirmPassword,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/change-password-first-time'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'JWT_TOKEN=$token',
      },
      body: jsonEncode({
        'code': code,
        'password': newPassword,
        'confirmPassword': confirmPassword
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Échec de la réinitialisation du mot de passe');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> sendEmailVerfication(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/reset-password-email'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "email": email,
        },
      ),
    );
    if (res.statusCode != 200) {
      throw Exception('Échec de la réinitialisation du mot de passe');
    }
  }

  Future<void> verifCode(String email, String code) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/confirm-code'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'code': code,
        },
      ),
    );
    if (res.statusCode != 200) {
      throw Exception('Échec de la Verification du code');
    }
    if (res.statusCode != 400) {
      throw Exception('Code n\'est pas correct');
    }
  }

  Future<void> resetPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      ),
    );
    if (res.statusCode != 200) {
      throw Exception('Échec de la Verification du code');
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage(
    File image,
    String? token,
  ) async {
    var uri = Uri.parse('$baseUrl/files/upload');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath('file', image.path),
    );
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Cookie'] = 'JWT_TOKEN=$token';

    var response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      return jsonDecode(resStr);
    } else {
      throw Exception("Image upload failed");
    }
  }

  Future<Map<String, dynamic>> updateMobileUser({
    required String firstname,
    required String lastname,
    required String email,
    String? profilePicture,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl/user/updateMobileUser');
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'JWT_TOKEN=$token',
      },
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        if (profilePicture != null) 'profilePicture': profilePicture,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update user");
    }
  }
}
