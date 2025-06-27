import 'package:blogs_app/core/common/bloc/app_user_bloc.dart';
import 'package:blogs_app/features/Auth/data/datasources/auth_data_source.dart';
import 'package:blogs_app/features/Auth/data/repository/auth_repository_impl.dart';
import 'package:blogs_app/features/Auth/domain/repository/auth_repository.dart';
import 'package:blogs_app/features/Auth/domain/usecase/get_current_user.dart';
import 'package:blogs_app/features/Auth/domain/usecase/log_in_user.dart';
import 'package:blogs_app/features/Auth/domain/usecase/sign_up_user.dart';
import 'package:blogs_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/blog/data/datasources/blog_data_source.dart';
import 'package:blogs_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blogs_app/features/blog/domain/repository/blog_repository.dart';
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
import 'package:blogs_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void initDependencies() {
  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
  serviceLocator.registerLazySingleton(() => routeObserver);
  serviceLocator.registerLazySingleton<NavigatorObserver>(() => routeObserver);
  serviceLocator.registerLazySingleton(() => FlutterSecureStorage());
  serviceLocator.registerLazySingleton(() => AppUserBloc());
  _initAuth();
  _initBlog();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthDataSource>(() => AuthDataSourceImpl())
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(serviceLocator(), serviceLocator()))
    ..registerFactory<SignUpUser>(() => SignUpUser(serviceLocator()))
    ..registerFactory<LogInUser>(() => LogInUser(serviceLocator()))
    ..registerFactory<GetCurrentUser>(() => GetCurrentUser(serviceLocator()))
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogDataSource>(() => BlogDataSourceImpl())
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(serviceLocator()))
    ..registerFactory<GetAllBlogs>(() => GetAllBlogs(serviceLocator()))
    ..registerFactory(() => AddComment(serviceLocator()))
    ..registerFactory(() => CreateBlog(serviceLocator()))
    ..registerFactory(() => DeleteComment(serviceLocator()))
    ..registerFactory(() => GetAllCategories(serviceLocator()))
    ..registerFactory(() => GetBlogByCategory(serviceLocator()))
    ..registerFactory(() => LikeBlog(serviceLocator()))
    ..registerFactory(() => GetComments(serviceLocator()))
    ..registerFactory(() => GetMyBlogs(serviceLocator()))
    ..registerFactory(() => DeleteBlog(serviceLocator()))
    ..registerLazySingleton<BlogBloc>(
      () => BlogBloc(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
}
