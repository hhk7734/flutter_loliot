import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../authentication/authentication.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({@required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignInState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> signInWithEmailAndPassword() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    String result = await _authenticationRepository.signInWithEmailAndPassword(
      email: state.email.value,
      password: state.password.value,
    );
    emit(_parseSignInResult(state, result));
  }

  Future<void> signInWithGitHub({BuildContext context}) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    String result =
        await _authenticationRepository.signInWithGitHub(context: context);
    emit(_parseSignInResult(state, result));
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    String result = await _authenticationRepository.signInWithGoogle();
    emit(_parseSignInResult(state, result));
  }

  SignInState _parseSignInResult(SignInState state, String result) {
    switch (result) {
      case "success":
        return state.copyWith(status: FormzStatus.submissionSuccess);
      default:
        return state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
