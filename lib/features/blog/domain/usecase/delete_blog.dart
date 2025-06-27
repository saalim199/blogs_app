import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<String, DeleteBlogParams> {
  final BlogRepository _blogRepository;
  DeleteBlog(this._blogRepository);
  @override
  Future<Either<Failure, String>> call(DeleteBlogParams params) async {
    return await _blogRepository.deleteBlog(params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  DeleteBlogParams(this.blogId);
}
