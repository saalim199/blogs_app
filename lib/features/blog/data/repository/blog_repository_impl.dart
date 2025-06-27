import 'dart:developer';

import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/core/error/failure.dart';
import 'package:blogs_app/features/blog/data/datasources/blog_data_source.dart';
import 'package:blogs_app/features/blog/data/model/blog_model.dart';
import 'package:blogs_app/features/blog/data/model/comment_model.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogDataSource _blogDataSource;
  BlogRepositoryImpl(this._blogDataSource);
  @override
  Future<Either<Failure, String>> addComment(String content, String blogId) async {
    try {
      String response = await _blogDataSource.addComment(content, blogId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, BlogModel>> createBlog(String title, String content, List<String> categories) async {
    try {
      BlogModel blog = await _blogDataSource.createBlog(title, content, categories);
      return Right(blog);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteComment(String commentId, String blogId) async {
    try {
      String response = await _blogDataSource.deleteComment(commentId, blogId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlogModel>>> getAllBlogs() async {
    try {
      List<BlogModel> blogs = await _blogDataSource.fetchAllBlogs();
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlogModel>>> getBlogsByCategory(String categoryName) async {
    try {
      List<BlogModel> blogs = await _blogDataSource.fetchBlogsByCategory(categoryName);
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> likeBlog(String blogId) async {
    try {
      String response = await _blogDataSource.likeBlog(blogId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllCategories() async {
    try {
      List<String> categories = await _blogDataSource.fetchAllCategories();
      log('Fetched categories: $categories');
      return Right(categories);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getComments(String blogId) async {
    try {
      List<CommentModel> comments = await _blogDataSource.fetchComments(blogId);
      return Right(comments);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getMyBlogs() async {
    try {
      List<BlogModel> blogs = await _blogDataSource.fetchMyBlogs();
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteBlog(String blogId) async {
    try {
      String response = await _blogDataSource.deleteBlog(blogId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
