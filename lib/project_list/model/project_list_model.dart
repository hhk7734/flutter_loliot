import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project/project.dart';

part 'project_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectListModel {
  ProjectListModel({
    List<ProjectModel> projectModelList,
    this.reactGridViewModel,
  }) : this.projectModelList = projectModelList ?? <ProjectModel>[];

  List<ProjectModel> projectModelList;

  ReactGridViewModel reactGridViewModel;

  // JsonSerializable

  factory ProjectListModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListModelToJson(this);
}
