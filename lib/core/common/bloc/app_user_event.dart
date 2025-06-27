part of 'app_user_bloc.dart';

@immutable
sealed class AppUserEvent {}

final class updateUser extends AppUserEvent {
  final User? user;
  updateUser(this.user);
}
