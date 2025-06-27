import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class LikeBlog implements UseCase<String, LikeBlogParams> {
  final BlogRepository _blogRepository;

  LikeBlog(this._blogRepository);
  @override
  Future<Either<Failure, String>> call(LikeBlogParams params) async {
    return await _blogRepository.likeBlog(params.blogId);
  }
}

class LikeBlogParams {
  final String blogId;

  LikeBlogParams({required this.blogId});
}
