import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

part 'project_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectListModel {
  ProjectListModel({
    Set<String> projectNameSet,
    this.reactGridViewModel,
  }) : this.projectNameSet = projectNameSet ?? <String>{};

  Set<String> projectNameSet;

  ReactGridViewModel reactGridViewModel;

  // JsonSerializable

  factory ProjectListModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListModelToJson(this);

  factory ProjectListModel.fromString(String jsonString) =>
      ProjectListModel.fromJson(jsonDecode(jsonString));

  String toString() => jsonEncode(toJson());
}
