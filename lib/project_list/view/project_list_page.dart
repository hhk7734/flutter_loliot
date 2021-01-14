import 'package:flutter/material.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project/project.dart';
import '../project_list.dart';

class ProjectListPage extends StatelessWidget {
  ProjectListPage({
    Key key,
    ProjectListModel model,
    List<ProjectModel> projectModelList,
  })  : reactGridView = ReactGridView.fromModel(
          children: projectModelList
              .map<ReactPositioned>((e) => e.toAvatar())
              .toList(),
          model: model.reactGridViewModel,
        ),
        super(key: key);

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
    ProjectListModel model,
    List<ProjectModel> projectModelList,
  }) {
    return MaterialPageRoute<void>(
        builder: (_) => ProjectListPage(
              model: model,
              projectModelList: projectModelList,
            ));
  }
}
