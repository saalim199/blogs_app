import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/utils/show_snack_bar.dart';
import 'package:blogs_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/Auth/presentation/screens/signup_page.dart';
import 'package:blogs_app/features/Auth/presentation/widgets/gradient_button.dart';
import 'package:blogs_app/features/Auth/presentation/widgets/text_field.dart';
import 'package:blogs_app/features/blog/presentation/screens/blog_home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }
            if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(context, BlogHomePage.route(), (route) => false);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Login.', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    AuthTextField(controller: usernameController, hintText: 'Username'),
                    const SizedBox(height: 15),
                    AuthTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                    const SizedBox(height: 20),
                    GradientButton(
                      buttonText: 'Login',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthSignIn(
                              username: usernameController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              color: AppPallete.gradient2,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, SignupPage.route());
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
