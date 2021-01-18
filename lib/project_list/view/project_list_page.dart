import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../project_list.dart';
import '../../authentication/authentication.dart';
import '../../loliot/loliot.dart';

class ProjectListPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProjectListPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectListCubit>(
      create: (context) =>
          ProjectListCubit(loliotRepository: context.read<LoliotRepository>())
            ..initView(context),
      child: _ProjectListPage(),
    );
  }
}

class _ProjectListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project List"),
        actions: [
          IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                context.read<ProjectListCubit>().createProject(context);
              }),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context
                  .read<AuthenticationCubit>()
                  .authenticationLogoutRequested();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProjectListCubit, ProjectListState>(
        builder: (context, state) {
          switch (state.status) {
            case ProjectListStatus.success:
              return state.reactGridView;
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
