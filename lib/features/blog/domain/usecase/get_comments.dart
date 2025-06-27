import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/comment.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetComments implements UseCase<List<Comment>, GetCommentsParams> {
  final BlogRepository _blogRepository;

  GetComments(this._blogRepository);
  @override
  Future<Either<Failure, List<Comment>>> call(GetCommentsParams params) async {
    return await _blogRepository.getComments(params.blogId);
  }
}

class GetCommentsParams {
  final String blogId;

  GetCommentsParams({required this.blogId});
}
