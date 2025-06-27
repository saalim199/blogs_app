import 'package:blogs_app/core/common/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'app_user_event.dart';
part 'app_user_state.dart';

class AppUserBloc extends Bloc<AppUserEvent, AppUserState> {
  AppUserBloc() : super(AppUserInitial()) {
    on<updateUser>((event, emit) {
      if (event.user != null) {
        emit(AppUserLoggedIn(event.user!));
      } else {
        emit(AppUserInitial());
      }
    });
  }
}
