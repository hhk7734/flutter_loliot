import 'package:flutter/material.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project_list.dart';

class ProjectListPage extends StatelessWidget {
  ProjectListPage({
    Key key,
    ProjectListModel model,
  })  : reactGridView = ReactGridView.fromModel(
            children: model.projectModelList
                .map((e) => ReactPositioned.fromModel(
                      model: e.reactPositionedModel,
                    ))
                .toList(),
            model: model.reactGridViewModel),
        super(key: key);

  static Route route(ProjectListModel model) {
    return MaterialPageRoute<void>(
        builder: (_) => ProjectListPage(model: model));
  }

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
}
