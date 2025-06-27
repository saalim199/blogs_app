import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetBlogByCategory implements UseCase<List<Blog>, GetBlogByCategoryParams> {
  final BlogRepository _blogRepository;

  GetBlogByCategory(this._blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(GetBlogByCategoryParams params) async {
    return await _blogRepository.getBlogsByCategory(params.categoryName);
  }
}

class GetBlogByCategoryParams {
  final String categoryName;

  GetBlogByCategoryParams({required this.categoryName});
}
