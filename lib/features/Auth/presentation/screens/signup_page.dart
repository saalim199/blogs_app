import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:blogs_app/core/common/widgets/loader.dart';
import 'package:blogs_app/core/utils/show_snack_bar.dart';
import 'package:blogs_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/Auth/presentation/screens/login_page.dart';
import 'package:blogs_app/features/Auth/presentation/widgets/gradient_button.dart';
import 'package:blogs_app/features/Auth/presentation/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppPallete.backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is AuthSuccess) {
              showSnackBar(context, 'User registered successfully');
              Navigator.pushAndRemoveUntil(context, LoginPage.route(), (route) => false);
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
                    const Text('Sign Up.', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    AuthTextField(controller: nameController, hintText: 'Username'),
                    const SizedBox(height: 15),
                    AuthTextField(controller: emailController, hintText: 'Email'),
                    const SizedBox(height: 15),
                    AuthTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                    const SizedBox(height: 15),
                    AuthTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      buttonText: 'Sign Up',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            AuthSignUp(
                              username: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              confirmPassword: confirmPasswordController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(context, LoginPage.route());
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
