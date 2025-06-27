import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateBlog implements UseCase<Blog, CreateBlogParams> {
  final BlogRepository _blogRepository;

  CreateBlog(this._blogRepository);
  @override
  Future<Either<Failure, Blog>> call(CreateBlogParams params) async {
    return await _blogRepository.createBlog(params.title, params.content, params.categories);
  }
}

class CreateBlogParams {
  final String title;
  final String content;
  final List<String> categories;

  CreateBlogParams({required this.title, required this.content, required this.categories});
}
