import 'package:blogs_app/core/common/bloc/app_user_bloc.dart';
import 'package:blogs_app/core/common/user.dart';
import 'package:blogs_app/core/usecase/usecase.dart';
import 'package:blogs_app/features/Auth/domain/usecase/get_current_user.dart';
import 'package:blogs_app/features/Auth/domain/usecase/log_in_user.dart';
import 'package:blogs_app/features/Auth/domain/usecase/sign_up_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUser _signUpUser;
  final LogInUser _logInUser;
  final GetCurrentUser _getCurrentUser;
  final AppUserBloc _appUserBloc;
  AuthBloc(this._signUpUser, this._logInUser, this._getCurrentUser, this._appUserBloc) : super(AuthInitial()) {
    on<AuthSignUp>(_authSignUp);

    on<AuthSignIn>(_authSignIn);

    on<IsUserLoggedIn>(_isUserLoggedIn);
  }

  void _authSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _logInUser(UserLogInParams(username: event.username, password: event.password));
    res.fold((failure) => emit(AuthFailure(failure.message)), (user) => _emitAuthSuccess(user, emit));
  }

  void _authSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _signUpUser(
      UserSignUpParams(
        username: event.username,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );
    res.fold((failure) => emit(AuthFailure(failure.message)), (message) => emit(AuthSuccess(message, null)));
  }

  void _isUserLoggedIn(IsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _getCurrentUser(NoParams());
    res.fold((failure) => emit(AuthInitial()), (user) => _emitAuthSuccess(user, emit));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserBloc.add(updateUser(user));
    emit(AuthSuccess('Success', user));
  }
}
