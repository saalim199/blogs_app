import 'package:blogs_app/core/common/user.dart';
import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/features/Auth/data/datasources/auth_data_source.dart';
import 'package:blogs_app/features/Auth/data/model/user_model.dart';
import 'package:blogs_app/features/Auth/domain/repository/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final FlutterSecureStorage _storage;
  AuthRepositoryImpl(this._authDataSource, this._storage);
  @override
  Future<Either<Failure, User>> loginWithUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    try {
      UserModel user = await _authDataSource.loginWithUsernameAndPassword(username: username, password: password);
      if (user.token != null) {
        await saveToken(user.token!);
      }
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to login with username and password'));
    }
  }

  @override
  Future<Either<Failure, String>> signUpWithUsernameAndPassword({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      String message = await _authDataSource.signUpWithUsernameAndPassword(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to sign up with username and password'));
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      String? token = await getToken();
      if (token == null) {
        return Left(Failure('No token found'));
      }
      UserModel? user = await _authDataSource.getCurrentUser(token);
      if (user == null) {
        return Left(Failure('No user found'));
      }
      return Right(user);
    } catch (e) {
      return Left(Failure('Failed to get current user'));
    }
  }
}
