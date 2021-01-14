import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:react_grid_view/react_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/authentication.dart';
import 'project_list/project/project.dart';
import 'project_list/project_list.dart';
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

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
              return RepositoryProvider.value(
                  value: authenticationRepository,
                  child: BlocProvider(
                    create: (_) => AuthenticationCubit(
                        authenticationRepository: authenticationRepository),
                    child:
                        BlocListener<AuthenticationCubit, AuthenticationState>(
                      listener: (_, state) {
                        switch (state.status) {
                          case AuthenticationStatus.authenticated:
                            _navigateToProjectListPage();
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

  void _navigateToProjectListPage() {
    _prefs.then((prefs) {
      String projectListString = prefs.getString("project_list_model");
      ProjectListModel projectListModel;
      if (projectListString != null) {
        projectListModel =
            ProjectListModel.fromJson(jsonDecode(projectListString));
      } else {
        projectListModel = ProjectListModel(
          reactGridViewModel: ReactGridViewModel(
            alignment: ReactGridViewAlignment.sequential,
            crossAxisCount: 2,
            mainAxisCount: 6,
          ),
        );
      }

      _navigator.pushAndRemoveUntil<void>(
        ProjectListPage.route(
          model: projectListModel,
          projectModelList:
              projectListModel.projectNameList.map<ProjectModel>((e) {
            String projectString = prefs.getString(e);
            return ProjectModel.fromJson(jsonDecode(projectString));
          }).toList(),
        ),
        (route) => false,
      );
    });
  }
}
