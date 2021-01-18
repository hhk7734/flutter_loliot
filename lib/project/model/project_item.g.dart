// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectItem _$ProjectItemFromJson(Map<String, dynamic> json) {
  return ProjectItem(
    reactPositionedModel: json['reactPositionedModel'] == null
        ? null
        : ReactPositionedModel.fromJson(
            json['reactPositionedModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectItemToJson(ProjectItem instance) =>
    <String, dynamic>{
      'reactPositionedModel': instance.reactPositionedModel?.toJson(),
    };
