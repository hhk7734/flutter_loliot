import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project.dart';

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

  @JsonKey(ignore: true)
  ProjectCubit cubit;

  final ProjectItemType projectItemType;

  ReactPositionedModel reactPositionedModel;

  @JsonKey(ignore: true)
  ReactPositioned reactPositioned;

  Widget _build() {
    switch (projectItemType) {
      case ProjectItemType.button:
        return _buildButton();
      default:
        return Container(
          color: Colors.grey,
        );
    }
  }

  Widget _buildButton() {
    return BlocBuilder<ProjectCubit, ProjectState>(
      cubit: cubit,
      buildWhen: (previous, current) => previous.activate != current.activate,
      builder: (context, state) {
        if (state.activate) {
          return Container(
            color: Colors.red,
          );
        }
        return Container(
          color: Colors.blue,
        );
      },
    );
  }

  ReactPositioned toWidget() {
    if (reactPositioned == null)
      reactPositioned = ReactPositioned.fromModel(
        child: _build(),
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
