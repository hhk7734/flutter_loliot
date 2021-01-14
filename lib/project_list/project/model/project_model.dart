import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

part 'project_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectModel {
  ProjectModel({
    this.reactGridViewModel,
    this.reactPositionedModel,
  });

  ReactGridViewModel reactGridViewModel;

  ReactPositionedModel reactPositionedModel;

  // JsonSerializable

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}
