import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

part 'project_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectItemModel {
  ProjectItemModel({
    this.reactPositionedModel,
  });

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
      );

    return reactPositioned;
  }

  // JsonSerializable

  factory ProjectItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectItemModelToJson(this);
}
