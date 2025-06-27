import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddComment implements UseCase<String, AddCommentParams> {
  final BlogRepository _blogRepository;

  AddComment(this._blogRepository);
  @override
  Future<Either<Failure, String>> call(AddCommentParams params) async {
    return await _blogRepository.addComment(params.content, params.blogId);
  }
}

class AddCommentParams {
  final String blogId;
  final String content;

  AddCommentParams({required this.blogId, required this.content});
}
