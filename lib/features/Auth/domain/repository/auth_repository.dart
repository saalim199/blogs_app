import 'package:blogs_app/core/common/user.dart';
import 'package:blogs_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signUpWithUsernameAndPassword({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<Either<Failure, User>> loginWithUsernameAndPassword({required String username, required String password});

  Future<Either<Failure, User>> getCurrentUser();
}
