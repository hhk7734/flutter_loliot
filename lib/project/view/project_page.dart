import 'package:flutter/material.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({this.model})
      : reactGridView = ReactGridView.fromModel(
          model: model.reactGridViewModel,
        );

  final ProjectModel model;
  final ReactGridView reactGridView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project ${model.name}"),
      ),
      body: reactGridView,
    );
  }

  static Route route(ProjectModel model) {
    return MaterialPageRoute<void>(builder: (_) => ProjectPage(model: model));
  }
}
