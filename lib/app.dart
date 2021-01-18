import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication.dart';
import 'project_list/project_list.dart';
import 'loliot/loliot.dart';
import 'sign_in/sign_in.dart';
import 'splash/splash.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppView();
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (_, child) {
        return FutureBuilder(
          future: _initialization,
          builder: (_, snapshot) {
            // if (snapshot.hasError) {}
            if (snapshot.connectionState == ConnectionState.done) {
              final AuthenticationRepository authenticationRepository =
                  AuthenticationRepository();
              final LoliotRepository loliotRepository = LoliotRepository();
              return MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(create: (_) => authenticationRepository),
                    RepositoryProvider(create: (_) => loliotRepository),
                  ],
                  child: BlocProvider(
                    create: (_) => AuthenticationCubit(
                        authenticationRepository: authenticationRepository),
                    child:
                        BlocListener<AuthenticationCubit, AuthenticationState>(
                      listener: (_, state) {
                        switch (state.status) {
                          case AuthenticationStatus.authenticated:
                            loliotRepository.init().then(
                                (value) => _navigator.pushAndRemoveUntil<void>(
                                      ProjectListPage.route(),
                                      (route) => false,
                                    ));
                            break;
                          case AuthenticationStatus.unauthenticated:
                            _navigator.pushAndRemoveUntil<void>(
                              SignInPage.route(),
                              (route) => false,
                            );
                            break;
                          default:
                            break;
                        }
                      },
                      child: child,
                    ),
                  ));
            }
            return child;
          },
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
