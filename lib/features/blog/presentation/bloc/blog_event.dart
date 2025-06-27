part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogFetchAll extends BlogEvent {}

final class BlogFetchMyBlogs extends BlogEvent {}

final class BlogFetchByCategory extends BlogEvent {
  final String category;

  BlogFetchByCategory({required this.category});
}

final class BlogCreate extends BlogEvent {
  final String title;
  final String content;
  final List<String> categories;

  BlogCreate({required this.title, required this.content, required this.categories});
}

final class BlogFetchComments extends BlogEvent {
  final String blogId;

  BlogFetchComments({required this.blogId});
}

final class BlogLike extends BlogEvent {
  final String blogId;

  BlogLike({required this.blogId});
}

final class BlogCommentCreate extends BlogEvent {
  final String blogId;
  final String content;

  BlogCommentCreate({required this.blogId, required this.content});
}

final class BlogDelete extends BlogEvent {
  final String blogId;

  BlogDelete({required this.blogId});
}

final class BlogCommentDelete extends BlogEvent {
  final String blogId;
  final String commentId;

  BlogCommentDelete({required this.blogId, required this.commentId});
}
