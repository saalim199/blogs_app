import 'dart:convert';
import 'dart:developer';
import 'package:blogs_app/core/cache/category_cache.dart';
import 'package:blogs_app/core/common/bloc/app_user_bloc.dart';
import 'package:blogs_app/core/error/exceptions.dart';
import 'package:blogs_app/core/secrets/app_secrets.dart';
import 'package:blogs_app/features/blog/data/model/blog_model.dart';
import 'package:blogs_app/features/blog/data/model/category_model.dart';
import 'package:blogs_app/features/blog/data/model/comment_model.dart';
import 'package:blogs_app/init_dependencies.dart';
import 'package:http/http.dart' as http;

abstract interface class BlogDataSource {
  Future<List<BlogModel>> fetchAllBlogs();
  Future<List<BlogModel>> fetchBlogsByCategory(String categoryName);
  Future<BlogModel> createBlog(String title, String content, List<String> categories);
  Future<String> likeBlog(String blogId);
  Future<String> addComment(String content, String blogId);
  Future<String> deleteComment(String commentId, String blogId);
  Future<List<CommentModel>> fetchComments(String blogId);
  Future<List<String>> fetchAllCategories();
  Future<List<BlogModel>> fetchMyBlogs();
  Future<String> deleteBlog(String blogId);
}

class BlogDataSourceImpl implements BlogDataSource {
  String? get token => (serviceLocator<AppUserBloc>().state as AppUserLoggedIn).user.token;
  @override
  Future<String> addComment(String content, String blogId) async {
    try {
      var reposonse = await http
          .post(
            Uri.parse('${AppSecrets.blogApi}/$blogId/comment'),
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
            body: jsonEncode({'content': content}),
          )
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      if (data['message'] == 'Success') {
        return 'Success';
      } else {
        throw ServerException(data['message'] ?? 'Failed to add comment');
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      throw ServerException('Something went wrong while adding comment');
    }
  }

  @override
  Future<BlogModel> createBlog(String title, String content, List<String> categories) async {
    try {
      String url = '${AppSecrets.blogApi}?';
      for (String category in categories) {
        url += 'categories=$category&';
      }
      log('Creating blog with URL: $url');
      var reposonse = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
            body: jsonEncode({'title': title, 'content': content}),
          )
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      if (data['message'] == 'Success') {
        return BlogModel.fromMap(data['data']);
      } else {
        throw ServerException(data['message'] ?? 'Failed to create blog');
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error creating blog: ${e.toString()}');
      throw ServerException('Something went wrong!');
    }
  }

  @override
  Future<String> deleteComment(String commentId, String blogId) async {
    try {
      String url = '${AppSecrets.blogApi}/$blogId/comment/$commentId';
      var reposonse = await http
          .delete(Uri.parse(url), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      if (data['message'] == 'Success') {
        return 'Success';
      } else {
        throw ServerException(data['message']);
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      throw ServerException('Something went wrong!');
    }
  }

  @override
  Future<List<BlogModel>> fetchAllBlogs() async {
    try {
      String url = AppSecrets.blogApi;
      var reposonse = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      log('Fetched blogs data: ${data['data']}');
      if (data['message'] == 'Success') {
        final blogs = data['data'] as List;
        return blogs.map((blog) => BlogModel.fromMap(blog)).toList();
      } else {
        throw ServerException(data['message'] ?? 'Failed to get blogs');
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      throw ServerException('Something went wrong!$e');
    }
  }

  @override
  Future<List<String>> fetchAllCategories() async {
    try {
      List<String> cached = await CategoryCache.loadCategories();
      if (cached.isNotEmpty) {
        return cached;
      }
      String url = AppSecrets.categoryApi;
      var reposonse = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      if (data['message'] == 'Success') {
        final categories = (data['data'] as List).map((category) => CategoryModel.fromMap(category).name).toList();
        await CategoryCache.saveCategories(categories);
        return categories;
      } else {
        throw ServerException(data['message']);
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error fetching categories: ${e.toString()}');
      throw ServerException('Something went wrong!');
    }
  }

  @override
  Future<List<BlogModel>> fetchBlogsByCategory(String categoryName) async {
    try {
      String url = '${AppSecrets.blogApi}/category/$categoryName';
      var reposonse = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      if (data['message'] == 'Success') {
        return (data['data'] as List).map((blog) => BlogModel.fromMap(blog)).toList();
      } else {
        throw ServerException(data['message'] ?? 'Failed to get blogs');
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      throw ServerException('Something went wrong!');
    }
  }

  @override
  Future<String> likeBlog(String blogId) async {
    try {
      String url = '${AppSecrets.blogApi}/$blogId/like';
      var reposonse = await http
          .put(Uri.parse(url), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      if (data['message'] == 'Success') {
        return 'Success';
      } else {
        throw ServerException(data['message'] ?? 'Failed to like blog');
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      throw ServerException('Something went wrong!');
    }
  }

  @override
  Future<List<CommentModel>> fetchComments(String blogId) async {
    try {
      String url = '${AppSecrets.blogApi}/$blogId/comments';
      var reposonse = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      var data = jsonDecode(reposonse.body);
      if (data['message'] == 'Success') {
        return (data['data'] as List).map((comment) => CommentModel.fromMap(comment)).toList();
      } else {
        throw ServerException(data['message'] ?? 'Failed to get comments');
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error fetching comments: ${e.toString()}');
      throw ServerException('Something went wrong!');
    }
  }

  @override
  Future<List<BlogModel>> fetchMyBlogs() async {
    try {
      String url = '${AppSecrets.blogApi}/my-blogs';
      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      var data = jsonDecode(response.body);
      if (data['message'] == 'Success') {
        final blogs = data['data'] as List;
        return blogs.map((blog) => BlogModel.fromMap(blog)).toList();
      } else {
        throw ServerException(data['message']);
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error fetching my blogs: ${e.toString()}');
      throw ServerException('Something went wrong!');
    }
  }

  @override
  Future<String> deleteBlog(String blogId) async {
    try {
      String url = '${AppSecrets.blogApi}/$blogId';
      var response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      var data = jsonDecode(response.body);
      if (data['message'] == 'Success') {
        return 'Success';
      } else {
        throw ServerException(data['message']);
      }
    } on ServerException catch (_) {
      rethrow;
    } catch (e) {
      log('Error deleting blog: ${e.toString()}');
      throw ServerException('Something went wrong!');
    }
  }
}
