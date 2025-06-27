part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  AuthSignUp({required this.username, required this.email, required this.password, required this.confirmPassword});
}

final class AuthSignIn extends AuthEvent {
  final String username;
  final String password;
  AuthSignIn({required this.username, required this.password});
}

final class IsUserLoggedIn extends AuthEvent {}
