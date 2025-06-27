import 'package:blogs_app/core/utils/date_format.dart';
import 'package:blogs_app/features/blog/domain/entity/blog.dart';
import 'package:blogs_app/features/blog/presentation/screens/view_blog_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(ViewBlogPage.route(blog)),
      child: Container(
        height: 200,
        margin: EdgeInsets.all(15).copyWith(bottom: 4),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.categories
                        .map(
                          (c) => Padding(
                            padding: EdgeInsets.all(5),
                            child: Chip(label: Text(c.name)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('By : ${blog.author.username}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text(
                  formatDateBydMMMYYYY(blog.createdAt),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
