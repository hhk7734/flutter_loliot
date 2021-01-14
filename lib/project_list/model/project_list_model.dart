import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

part 'project_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectListModel {
  ProjectListModel({
    List<String> projectNameList,
    this.reactGridViewModel,
  }) : this.projectNameList = projectNameList ?? <String>[];

  List<String> projectNameList;

  ReactGridViewModel reactGridViewModel;

  // JsonSerializable

  factory ProjectListModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListModelToJson(this);
}
