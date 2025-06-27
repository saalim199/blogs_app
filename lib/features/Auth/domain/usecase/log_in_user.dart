import 'package:blogs_app/core/common/user.dart';
import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/Auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogInUser implements UseCase<User, UserLogInParams> {
  final AuthRepository authRepository;

  const LogInUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLogInParams params) async {
    return await authRepository.loginWithUsernameAndPassword(username: params.username, password: params.password);
  }
}

class UserLogInParams {
  final String username;
  final String password;

  UserLogInParams({required this.username, required this.password});
}
