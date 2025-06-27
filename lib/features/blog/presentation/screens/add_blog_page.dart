import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:blogs_app/core/cache/category_cache.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/utils/show_snack_bar.dart';
import 'package:blogs_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/presentation/widgets/add_blog_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const AddBlogPage());
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> categories = [];
  List<String> selectedCategories = [];

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    categories = await CategoryCache.loadCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<BlogBloc>().add(
                  BlogCreate(
                    title: titleController.text,
                    content: contentController.text,
                    categories: selectedCategories,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
          if (state is BlogCreateSuccess) {
            showSnackBar(context, 'Blog created successfully!');
            context.read<BlogBloc>().add(BlogFetchAll());
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Add Blog.', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedCategories.contains(category)) {
                                      selectedCategories.remove(category);
                                    } else {
                                      selectedCategories.add(category);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(category),
                                    color: selectedCategories.contains(category)
                                        ? const WidgetStatePropertyAll(AppPallete.gradient1)
                                        : null,
                                    side: selectedCategories.contains(category)
                                        ? null
                                        : const BorderSide(color: AppPallete.borderColor),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AddBlogFormField(controller: titleController, hintText: 'Title'),
                    const SizedBox(height: 20),
                    AddBlogFormField(controller: contentController, hintText: 'Content'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
