import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteComment implements UseCase<String, DeleteCommentParams> {
  final BlogRepository _blogRepository;

  DeleteComment(this._blogRepository);
  @override
  Future<Either<Failure, String>> call(DeleteCommentParams params) async {
    return await _blogRepository.deleteComment(params.commentId, params.blogId);
  }
}

class DeleteCommentParams {
  final String commentId;
  final String blogId;

  DeleteCommentParams({required this.commentId, required this.blogId});
}
