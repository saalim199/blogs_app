import 'package:blogs_app/core/common/user.dart';
import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/Auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUser implements UseCase<User, NoParams> {
  final AuthRepository _authRepository;
  GetCurrentUser(this._authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _authRepository.getCurrentUser();
  }
}
