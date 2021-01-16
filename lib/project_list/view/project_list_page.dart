import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project_list.dart';

class ProjectListPage extends StatefulWidget {
  @override
  _ProjectListPageState createState() => _ProjectListPageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProjectListPage());
  }
}

class _ProjectListPageState extends State<ProjectListPage> {
  ProjectRepository projectRepository;
  ReactGridView reactGridView;

  @override
  void initState() {
    super.initState();
    projectRepository = context.read<ProjectRepository>();
    reactGridView = ReactGridView.fromModel(
      children: projectRepository.projectModelList
          .map<ReactPositioned>((e) => e.toAvatar())
          .toList(),
      model: projectRepository.projectListModel.reactGridViewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project List"),
      ),
      body: reactGridView,
    );
  }
}
