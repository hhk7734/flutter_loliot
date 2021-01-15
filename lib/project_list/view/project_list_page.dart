import 'package:flutter/material.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project_list.dart';

class ProjectListPage extends StatelessWidget {
  ProjectListPage({
    Key key,
    @required ProjectRepository projectRepository,
  })  : projectRepository = projectRepository,
        reactGridView = ReactGridView.fromModel(
          children: projectRepository.projectModelList
              .map<ReactPositioned>((e) => e.toAvatar())
              .toList(),
          model: projectRepository.projectListModel.reactGridViewModel,
        ),
        super(key: key);

  final ProjectRepository projectRepository;
  final ReactGridView reactGridView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project List"),
      ),
      body: reactGridView,
    );
  }

  static Route route({
    Key key,
    @required ProjectRepository projectRepository,
  }) {
    return MaterialPageRoute<void>(
        builder: (_) => ProjectListPage(
              key: key,
              projectRepository: projectRepository,
            ));
  }
}
