import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:blogs_app/core/common/bloc/app_user_bloc.dart';
import 'package:blogs_app/core/utils/date_format.dart';
import 'package:blogs_app/core/utils/show_snack_bar.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/presentation/widgets/comment_section.dart';
import 'package:blogs_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewBlogPage extends StatefulWidget {
  static route(Blog blog) => MaterialPageRoute(builder: (context) => ViewBlogPage(blog: blog));
  final Blog blog;
  const ViewBlogPage({super.key, required this.blog});

  @override
  State<ViewBlogPage> createState() => _ViewBlogPageState();
}

class _ViewBlogPageState extends State<ViewBlogPage> {
  int _totalComments = 0;
  bool _isLiked = false;
  String userId = (serviceLocator<AppUserBloc>().state as AppUserLoggedIn).user.id;

  @override
  void initState() {
    super.initState();
    _totalComments = widget.blog.comments.length;
    _isLiked = widget.blog.likedBy.any((user) => user.id == userId);
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => CommentSection(blogId: widget.blog.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (userId == widget.blog.author.id)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Blog'),
                    content: const Text('Are you sure you want to delete this blog?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          context.read<BlogBloc>().add(BlogDelete(blogId: widget.blog.id));
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0).copyWith(bottom: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.blog.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Text(
                      'By: ${widget.blog.author.username}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Published on: ${formatDateBydMMMYYYY(widget.blog.createdAt)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppPallete.greyColor,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(widget.blog.content, style: const TextStyle(fontSize: 16, height: 2)),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppPallete.gradient3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    label: Text(
                      'Like (${widget.blog.likedBy.length})',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    icon: (_isLiked) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border, size: 18),
                    onPressed: () {
                      context.read<BlogBloc>().add(BlogLike(blogId: widget.blog.id));
                      _isLiked = !_isLiked;
                      (_isLiked)
                          ? widget.blog.likedBy.add((serviceLocator<AppUserBloc>().state as AppUserLoggedIn).user)
                          : widget.blog.likedBy.removeWhere(
                              (user) => user.id == (serviceLocator<AppUserBloc>().state as AppUserLoggedIn).user.id,
                            );
                      setState(() {});
                    },
                  ),
                  TextButton.icon(
                    label: BlocListener<BlogBloc, BlogState>(
                      listener: (context, state) {
                        if (state is BlogCommentsFetchSuccess) {
                          _totalComments = state.comments.length;
                          setState(() {});
                        }
                        if (state is BlogDeleteSuccess) {
                          Navigator.of(context).pop();
                          showSnackBar(context, 'Blog deleted successfully');
                        }
                      },
                      child: Text(
                        'Comment($_totalComments)',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                    icon: const Icon(Icons.comment_outlined, size: 18),
                    onPressed: () => _showComments(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
