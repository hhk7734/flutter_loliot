import 'package:json_annotation/json_annotation.dart';
import 'package:react_grid_view/react_grid_view.dart';

part 'project_item.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectItem {
  ProjectItem({
    this.reactPositionedModel,
  });

  ReactPositionedModel reactPositionedModel;

  // JsonSerializable

  factory ProjectItem.fromJson(Map<String, dynamic> json) =>
      _$ProjectItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectItemToJson(this);
}
