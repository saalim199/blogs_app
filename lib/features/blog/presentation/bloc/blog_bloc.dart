import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/domain/entity/comment.dart';
import 'package:blogs_app/features/blog/domain/usecase/add_comment.dart';
import 'package:blogs_app/features/blog/domain/usecase/create_blog.dart';
import 'package:blogs_app/features/blog/domain/usecase/delete_blog.dart';
import 'package:blogs_app/features/blog/domain/usecase/delete_comment.dart';
import 'package:blogs_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blogs_app/features/blog/domain/usecase/get_all_categories.dart';
import 'package:blogs_app/features/blog/domain/usecase/get_blog_by_category.dart';
import 'package:blogs_app/features/blog/domain/usecase/get_comments.dart';
import 'package:blogs_app/features/blog/domain/usecase/get_my_blogs.dart';
import 'package:blogs_app/features/blog/domain/usecase/like_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetAllBlogs _getAllBlogs;
  final CreateBlog _createBlog;
  final GetComments _getComments;
  final LikeBlog _likeBlog;
  final AddComment _addComment;
  final GetBlogByCategory _getBlogsByCategory;
  final GetMyBlogs _getMyBlogs;
  final GetAllCategories _getAllCategories;
  final DeleteBlog _deleteBlog;
  final DeleteComment _deleteComment;

  BlogBloc(
    this._getAllBlogs,
    this._createBlog,
    this._getComments,
    this._likeBlog,
    this._addComment,
    this._getBlogsByCategory,
    this._getMyBlogs,
    this._getAllCategories,
    this._deleteBlog,
    this._deleteComment,
  ) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogFetchAll>(_fetchAllBlogs);

    on<BlogCreate>(_createNewBlog);

    on<BlogFetchComments>(_fetchComments);

    on<BlogLike>(_likeABlog);

    on<BlogCommentCreate>(_createNewComment);

    on<BlogFetchByCategory>(_fetchBlogsByCategory);

    on<BlogFetchMyBlogs>(_fetchMyBlogs);

    on<BlogDelete>(_deleteBlogById);

    on<BlogCommentDelete>(_deleteAComment);
  }

  void _fetchAllBlogs(BlogFetchAll event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());
    await _getAllCategories(NoParams());
    res.fold((failure) => emit(BlogFailure(failure.message)), (blogs) => emit(BlogSuccess(blogs)));
  }

  void _createNewBlog(BlogCreate event, Emitter<BlogState> emit) async {
    final res = await _createBlog(
      CreateBlogParams(title: event.title, content: event.content, categories: event.categories),
    );
    res.fold((failure) => emit(BlogFailure(failure.message)), (blog) => emit(BlogCreateSuccess(blog)));
  }

  void _fetchComments(BlogFetchComments event, Emitter<BlogState> emit) async {
    final res = await _getComments(GetCommentsParams(blogId: event.blogId));
    res.fold((failure) => emit(BlogFailure(failure.message)), (comments) => emit(BlogCommentsFetchSuccess(comments)));
  }

  void _likeABlog(BlogLike event, Emitter<BlogState> emit) async {
    final res = await _likeBlog(LikeBlogParams(blogId: event.blogId));
    res.fold((failure) => emit(BlogFailure(failure.message)), (message) => emit(BlogLikeSuccess(message)));
  }

  void _createNewComment(BlogCommentCreate event, Emitter<BlogState> emit) async {
    final res = await _addComment(AddCommentParams(blogId: event.blogId, content: event.content));
    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (success) => add(BlogFetchComments(blogId: event.blogId)),
    );
  }

  void _fetchBlogsByCategory(BlogFetchByCategory event, Emitter<BlogState> emit) async {
    final res = await _getBlogsByCategory(GetBlogByCategoryParams(categoryName: event.category));
    res.fold((failure) => emit(BlogFailure(failure.message)), (blogs) => emit(BlogSuccess(blogs)));
  }

  void _fetchMyBlogs(BlogFetchMyBlogs event, Emitter<BlogState> emit) async {
    final res = await _getMyBlogs(NoParams());
    await _getAllCategories(NoParams());
    res.fold((failure) => emit(BlogFailure(failure.message)), (blogs) => emit(BlogSuccess(blogs)));
  }

  void _deleteBlogById(BlogDelete event, Emitter<BlogState> emit) async {
    final res = await _deleteBlog(DeleteBlogParams(event.blogId));
    res.fold((failure) => emit(BlogFailure(failure.message)), (message) => emit(BlogDeleteSuccess()));
  }

  void _deleteAComment(BlogCommentDelete event, Emitter<BlogState> emit) async {
    final res = await _deleteComment(DeleteCommentParams(blogId: event.blogId, commentId: event.commentId));
    res.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (message) => add(BlogFetchComments(blogId: event.blogId)),
    );
  }
}
