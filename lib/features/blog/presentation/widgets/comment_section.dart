import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:blogs_app/core/common/bloc/app_user_bloc.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/utils/show_snack_bar.dart';
import 'package:blogs_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentSection extends StatefulWidget {
  final String blogId;
  const CommentSection({super.key, required this.blogId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _controller = TextEditingController();
  String userId = (serviceLocator<AppUserBloc>().state as AppUserLoggedIn).user.id;
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchComments(blogId: widget.blogId));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scrollController) => BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          if (state is BlogCommentsFetchSuccess) {
            state.comments.sort((a, b) {
              if (a.authorId == userId && b.authorId != userId) return -1;
              if (a.authorId != userId && b.authorId == userId) return 1;
              return 0;
            });
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(color: AppPallete.backgroundColor, borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 10),
                const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                (state.comments.isEmpty)
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No comments yet.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      )
                    : Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          reverse: false,
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTapDown: (details) => _getTapPosition(details),
                            onLongPress: () {
                              if (state.comments[index].authorId != userId) return;
                              final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
                              showMenu(
                                context: context,
                                position: RelativeRect.fromRect(
                                  Rect.fromLTRB(_tapPosition.dx, _tapPosition.dy, 10, 10),
                                  Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width, overlay.paintBounds.size.height),
                                ),

                                items: [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                    onTap: () {
                                      context.read<BlogBloc>().add(
                                        BlogCommentDelete(blogId: widget.blogId, commentId: state.comments[index].id),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            child: ListTile(
                              title: Text(state.comments[index].authorName),
                              subtitle: Text(state.comments[index].content),
                            ),
                          ),
                        ),
                      ),
                const Divider(height: 1),
                Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: TextField(
                            controller: _controller,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            context.read<BlogBloc>().add(
                              BlogCommentCreate(blogId: widget.blogId, content: _controller.text.trim()),
                            );
                            _controller.clear();
                          } else {
                            showSnackBar(context, 'Comment cannot be empty');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
