import 'dart:convert';

import 'package:blogs_app/features/blog/domain/entity/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.postId,
    required super.authorId,
    required super.authorName,
    required super.content,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
