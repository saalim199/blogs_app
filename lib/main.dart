import 'package:blogs_app/core/Themes/theme.dart';
import 'package:blogs_app/core/common/bloc/app_user_bloc.dart';
import 'package:blogs_app/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:blogs_app/features/Auth/presentation/screens/login_page.dart';
import 'package:blogs_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_app/features/blog/presentation/screens/blog_home_page.dart';
import 'package:blogs_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserBloc>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(IsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkModeTheme,
      navigatorObservers: [serviceLocator<RouteObserver<ModalRoute<void>>>()],
      home: BlocSelector<AppUserBloc, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogHomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
