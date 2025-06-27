// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogs_app/core/common/user.dart';
import 'package:blogs_app/features/blog/domain/entity/category.dart';
import 'package:blogs_app/features/blog/domain/entity/comment.dart';

class Blog {
  final String id;
  final String title;
  final String content;
  final User author;
  final List<Comment> comments;
  final List<Category> categories;
  final List<User> likedBy;
  final DateTime createdAt;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.comments,
    required this.categories,
    required this.likedBy,
    required this.createdAt,
  });
}
