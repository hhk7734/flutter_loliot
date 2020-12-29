import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../authentication.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(
      {@required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.authUser.listen((authUser) {
      authenticationUserChanged(authUser);
    });
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthUser> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void authenticationLogoutRequested() {
    _authenticationRepository.signOut();
  }

  void authenticationUserChanged(AuthUser authUser) {
    emit(authUser != AuthUser.empty
        ? AuthenticationState.authenticated(authUser)
        : const AuthenticationState.unauthenticated());
  }
}
