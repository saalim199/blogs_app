import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository _blogRepository;

  GetAllBlogs(this._blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await _blogRepository.getAllBlogs();
  }
}
