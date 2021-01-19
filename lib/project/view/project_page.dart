import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../project.dart';
import '../../loliot/loliot.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({
    @required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectCubit>(
      create: (context) => ProjectCubit(
          loliotRepository: context.read<LoliotRepository>(), name: name)
        ..initView(),
      child: _ProjectPage(),
    );
  }

  static Route route(String name) {
    return MaterialPageRoute<void>(builder: (_) => ProjectPage(name: name));
  }
}

class _ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        switch (state.status) {
          case ProjectStatus.success:
            return Scaffold(
              appBar: AppBar(
                title: Text("Project"),
                actions: [],
              ),
              body: state.reactGridView,
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
