import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/entity/comment.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, List<Blog>>> getAllBlogs();
  Future<Either<Failure, List<Blog>>> getMyBlogs();
  Future<Either<Failure, String>> deleteBlog(String blogId);
  Future<Either<Failure, List<Blog>>> getBlogsByCategory(String categoryName);
  Future<Either<Failure, Blog>> createBlog(String title, String content, List<String> categories);
  Future<Either<Failure, String>> likeBlog(String blogId);
  Future<Either<Failure, String>> addComment(String content, String blogId);
  Future<Either<Failure, String>> deleteComment(String commentId, String blogId);
  Future<Either<Failure, List<String>>> getAllCategories();
  Future<Either<Failure, List<Comment>>> getComments(String blogId);
}
