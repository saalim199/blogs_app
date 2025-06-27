import 'dart:convert';
import 'dart:developer';

import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/core/secrets/app_secrets.dart';
import 'package:blogs_app/features/Auth/data/model/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthDataSource {
  Future<String> signUpWithUsernameAndPassword({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<UserModel> loginWithUsernameAndPassword({required String username, required String password});

  Future<UserModel?> getCurrentUser(String token);
}

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<String> signUpWithUsernameAndPassword({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      var response = await http
          .post(
            Uri.parse(AppSecrets.signupApi),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
              'confirmPassword': confirmPassword,
            }),
          )
          .timeout(const Duration(seconds: 20));
      final data = jsonDecode(response.body);
      if (data['message'] == 'Success') {
        return 'User registered successfully';
      }
      throw ServerException('Sign up failed: ${data['message']}');
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error during sign up: $e');
      throw ServerException('Failed to sign up with username and password');
    }
  }

  @override
  Future<UserModel> loginWithUsernameAndPassword({required String username, required String password}) async {
    try {
      var response = await http
          .post(
            Uri.parse(AppSecrets.loginApi),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"username": username, "password": password}),
          )
          .timeout(const Duration(seconds: 20));
      final data = jsonDecode(response.body);
      if (data['message'] == 'Success') {
        return UserModel.fromJson(data['data']);
      } else {
        log('Login failed: ${data['message']}');
        throw ServerException('Login failed: ${data['message']}');
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error during login: ${e.toString()}');
      throw ServerException('Failed to login with username and password');
    }
  }

  @override
  Future<UserModel?> getCurrentUser(String token) async {
    try {
      var response = await http
          .get(
            Uri.parse(AppSecrets.getCurrentUserApi),
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 20));
      final data = jsonDecode(response.body);
      if (data['message'] == 'Success') {
        log('Current user data: ${data['data']}');
        UserModel user = UserModel.fromJson(data['data']).copyWith(token: token);
        log('Current user token: ${user.token}');
        return user;
      } else {
        return null;
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error during get current user: ${e.toString()}');
      throw ServerException('Failed to get current user');
    }
  }
}
