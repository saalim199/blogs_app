import 'dart:developer';
import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:blogs_app/core/cache/category_cache.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blogs_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllBlogsPage extends StatefulWidget {
  final bool _isMyBlogs;
  const AllBlogsPage({super.key, required bool isMyBlogs}) : _isMyBlogs = isMyBlogs;

  @override
  State<AllBlogsPage> createState() => _AllBlogsPageState();
}

class _AllBlogsPageState extends State<AllBlogsPage> with RouteAware {
  int selectedCategoryIndex = 0;
  List<String> categories = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    serviceLocator<RouteObserver<ModalRoute<void>>>().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void initState() {
    super.initState();
    (widget._isMyBlogs)
        ? context.read<BlogBloc>().add(BlogFetchMyBlogs())
        : context.read<BlogBloc>().add(BlogFetchAll());
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    categories = await CategoryCache.loadCategories();
    categories.insert(0, 'All');
    setState(() {});
  }

  @override
  void dispose() {
    serviceLocator<RouteObserver<ModalRoute<void>>>().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    (widget._isMyBlogs)
        ? context.read<BlogBloc>().add(BlogFetchMyBlogs())
        : context.read<BlogBloc>().add(BlogFetchAll());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              if (state is BlogSuccess) {
                log('Fetched categories: $categories');
                return (!widget._isMyBlogs)
                    ? Row(
                        children: categories
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    if (category == 'All') {
                                      context.read<BlogBloc>().add(BlogFetchAll());
                                      selectedCategoryIndex = 0;
                                    } else {
                                      context.read<BlogBloc>().add(BlogFetchByCategory(category: category));
                                      selectedCategoryIndex = categories.indexOf(category);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(category),
                                    color: categories[selectedCategoryIndex] == category
                                        ? const WidgetStatePropertyAll(AppPallete.gradient1)
                                        : null,
                                    side: categories[selectedCategoryIndex] == category
                                        ? null
                                        : const BorderSide(color: AppPallete.borderColor),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : SizedBox();
              }
              return const SizedBox();
            },
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return Expanded(child: const Loader());
            }
            if (state is BlogFailure) {
              log('Error: ${state.message}');
              return Expanded(child: Center(child: Text(state.message)));
            }
            if (state is BlogSuccess) {
              final blogs = state.blogs;
              if (blogs.isEmpty) {
                return Expanded(child: const Center(child: Text('No blogs available.')));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      final blog = blogs[index];
                      return BlogCard(
                        blog: blog,
                        color: (index % 3 == 0)
                            ? Colors.blue
                            : (index % 3 == 1)
                            ? Colors.green
                            : Colors.orange,
                      );
                    },
                  ),
                );
              }
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
