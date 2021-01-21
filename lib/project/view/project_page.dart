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
      child: _ProjectPage(
        name: name,
      ),
    );
  }

  static Route route(String name) {
    return MaterialPageRoute<void>(builder: (_) => ProjectPage(name: name));
  }
}

class _ProjectPage extends StatefulWidget {
  _ProjectPage({
    @required this.name,
  });

  final String name;

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<_ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        switch (state.status) {
          case ProjectStatus.success:
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.name),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  )
                ],
              ),
              endDrawer: Drawer(
                child: _buildDrawer(),
              ),
              body: state.reactGridView,
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildDrawer() {
    return ListView(
      children: [
        RaisedButton(
          child: Container(
            child: Text("Button"),
          ),
          onPressed: () {
            context
                .read<ProjectCubit>()
                .addProjectItem(ProjectItemModel.button());
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
