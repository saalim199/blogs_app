part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogSuccess extends BlogState {
  final List<Blog> blogs;

  BlogSuccess(this.blogs);
}

final class BlogFailure extends BlogState {
  final String message;

  BlogFailure(this.message);
}

final class BlogCreateSuccess extends BlogState {
  final Blog blog;

  BlogCreateSuccess(this.blog);
}

final class BlogCommentsFetchSuccess extends BlogState {
  final List<Comment> comments;

  BlogCommentsFetchSuccess(this.comments);
}

final class BlogLikeSuccess extends BlogState {
  final String message;
  BlogLikeSuccess(this.message);
}

final class BlogDeleteSuccess extends BlogState {}
