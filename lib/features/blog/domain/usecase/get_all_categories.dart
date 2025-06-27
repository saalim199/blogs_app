import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllCategories implements UseCase<List<String>, NoParams> {
  final BlogRepository _blogRepository;

  GetAllCategories(this._blogRepository);
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await _blogRepository.getAllCategories();
  }
}
