import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../authentication.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GitHubSignIn _gitHubSignIn = GitHubSignIn(
      clientId: "3a2a23bd7518f1bc5207",
      clientSecret: "71bf9d2af625d524e494bd43ffb197afdd10499b",
      redirectUrl: "https://loliot-a960c.firebaseapp.com/__/auth/handler");
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

  Stream<AuthUser> get authUser {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? AuthUser.empty : firebaseUser.toAuthUser;
    });
  }

  Future<String> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
    return "success";
  }

  Future<String> signInWithGitHub({@required BuildContext context}) async {
    try {
      final githubResult = await _gitHubSignIn.signIn(context);
      if (githubResult.status == GitHubSignInResultStatus.ok) {
        final credential = GithubAuthProvider.credential(githubResult.token);
        await _firebaseAuth.signInWithCredential(credential);
      } else {
        return "github-access-failed";
      }
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
    return "success";
  }

  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
    return "success";
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<String> signUp({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
    return "success";
  }
}

extension on User {
  AuthUser get toAuthUser {
    return AuthUser(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
