part of 'authentication_cubit.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.authUser = AuthUser.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(AuthUser authUser)
      : this._(status: AuthenticationStatus.authenticated, authUser: authUser);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final AuthUser authUser;

  @override
  List<Object> get props => [status, authUser];
}
