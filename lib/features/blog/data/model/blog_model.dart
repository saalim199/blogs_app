import 'dart:convert';
import 'package:blogs_app/core/common/user.dart';
import 'package:blogs_app/features/blog/data/model/category_model.dart';
import 'package:blogs_app/features/blog/data/model/comment_model.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/entity/category.dart';
import 'package:blogs_app/features/blog/domain/entity/comment.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.content,
    required super.author,
    required super.comments,
    required super.categories,
    required super.likedBy,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'comments': comments,
      'categories': categories,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      author: (User.fromMap(map['author'])),
      comments: (map['comments'] ?? [])
          .map<Comment>((comment) => CommentModel.fromMap(comment as Map<String, dynamic>))
          .toList(),
      categories: (map['categories'] ?? [])
          .map<Category>((category) => CategoryModel.fromMap(category as Map<String, dynamic>))
          .toList(),
      likedBy: (map['likedBy'] ?? []).map<User>((user) => User.fromMap(user as Map<String, dynamic>)).toList(),
      createdAt: DateTime.parse(map['createdAt'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogModel.fromJson(String source) => BlogModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
