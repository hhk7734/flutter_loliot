import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

part 'project_item_model.g.dart';

enum ProjectItemType {
  button,
  horizontalSlider,
  joystick,
  verticalSlider,
}

@JsonSerializable(explicitToJson: true)
class ProjectItemModel {
  ProjectItemModel({
    this.projectItemType,
    this.reactPositionedModel,
  });

  factory ProjectItemModel.button() => ProjectItemModel(
        projectItemType: ProjectItemType.button,
        reactPositionedModel: ReactPositionedModel(
          crossAxisCount: 2,
          horizontalResizable: true,
          mainAxisCount: 2,
          maxCrossAxisCount: 4,
          maxMainAxisCount: 4,
          minCrossAxisCount: 1,
          minMainAxisCount: 1,
          movable: true,
          verticalResizable: true,
        ),
      );

  final ProjectItemType projectItemType;

  ReactPositionedModel reactPositionedModel;

  @JsonKey(ignore: true)
  ReactPositioned reactPositioned;

  ReactPositioned toWidget() {
    if (reactPositioned == null)
      reactPositioned = ReactPositioned.fromModel(
        child: Container(
          color: Colors.grey,
        ),
        model: reactPositionedModel,
        onModelChangeEnd: (index, model) => reactPositionedModel = model,
      );

    return reactPositioned;
  }

  // JsonSerializable

  factory ProjectItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectItemModelToJson(this);
}
