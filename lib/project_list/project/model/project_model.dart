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
    this.reactGridViewModel,
  });

  String name;

  ReactGridViewModel reactGridViewModel;

  ReactPositioned toAvatar(BuildContext context) {
    return ReactPositioned.fromModel(
      child: Container(
        color: Colors.grey,
        child: Center(
          child: Text("$name"),
        ),
      ),
      model: ReactPositionedModel(),
      onTapUp: (details) => Navigator.of(context).push(ProjectPage.route(this)),
    );
  }

  // JsonSerializable

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  factory ProjectModel.fromString(String jsonString) =>
      ProjectModel.fromJson(jsonDecode(jsonString));

  String toString() => jsonEncode(toJson());
}
