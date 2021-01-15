import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

part 'project_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectModel {
  ProjectModel({
    this.name,
    this.reactGridViewModel,
    this.reactPositionedModel,
  });

  String name;

  ReactGridViewModel reactGridViewModel;

  ReactPositionedModel reactPositionedModel;

  ReactPositioned toAvatar() {
    return ReactPositioned.fromModel(
      child: Container(
        color: Colors.grey,
        child: Center(
          child: Text("$name"),
        ),
      ),
      model: reactPositionedModel,
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
