import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project.dart';

part 'project_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectModel {
  ProjectModel({
    this.name,
    List<ProjectItem> projectItemList,
    ReactGridViewModel reactGridViewModel,
  })  : this.projectItemList = projectItemList ?? [],
        this.reactGridViewModel = reactGridViewModel ??
            ReactGridViewModel(
              alignment: ReactGridViewAlignment.none,
              crossAxisCount: 8,
              mainAxisCount: 12,
            );

  String name;

  List<ProjectItem> projectItemList;

  ReactGridViewModel reactGridViewModel;

  @JsonKey(ignore: true)
  ReactPositioned reactPositioned;

  ReactPositioned toAvatar(BuildContext context) {
    if (reactPositioned == null)
      reactPositioned = ReactPositioned.fromModel(
        child: Container(
          color: Colors.grey,
          child: Center(
            child: Text("$name"),
          ),
        ),
        model: ReactPositionedModel(),
        onTapUp: (details) =>
            Navigator.of(context).push(ProjectPage.route(this)),
      );

    return reactPositioned;
  }

  // JsonSerializable

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  factory ProjectModel.fromString(String jsonString) =>
      ProjectModel.fromJson(jsonDecode(jsonString));

  String toString() => jsonEncode(toJson());
}
