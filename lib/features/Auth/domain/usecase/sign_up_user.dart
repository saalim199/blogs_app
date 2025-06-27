import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/Auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignUpUser implements UseCase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  SignUpUser(this.authRepository);
  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithUsernameAndPassword(
      username: params.username,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}

class UserSignUpParams {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  UserSignUpParams({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
