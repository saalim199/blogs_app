import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:blogs_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/presentation/screens/add_blog_page.dart';
import 'package:blogs_app/features/blog/presentation/screens/all_blogs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogHomePage());
  const BlogHomePage({super.key});

  @override
  State<BlogHomePage> createState() => _BlogHomePageState();
}

class _BlogHomePageState extends State<BlogHomePage> {
  final PageController pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAll());
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(AddBlogPage.route());
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: const Icon(Icons.article_outlined), label: 'My Blogs'),
        ],
        backgroundColor: AppPallete.backgroundColor,
        selectedItemColor: AppPallete.gradient1,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          _currentPageIndex = index;
          pageController.jumpToPage(index);
          setState(() {});
        },
      ),
      body: PageView.builder(
        controller: pageController,

        itemBuilder: (context, index) {
          return index == 0 ? AllBlogsPage(isMyBlogs: false) : AllBlogsPage(isMyBlogs: true);
        },
        itemCount: 2,
        onPageChanged: (index) {
          _currentPageIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
