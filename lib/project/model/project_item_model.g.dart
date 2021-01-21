// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectItemModel _$ProjectItemModelFromJson(Map<String, dynamic> json) {
  return ProjectItemModel(
    reactPositionedModel: json['reactPositionedModel'] == null
        ? null
        : ReactPositionedModel.fromJson(
            json['reactPositionedModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectItemModelToJson(ProjectItemModel instance) =>
    <String, dynamic>{
      'reactPositionedModel': instance.reactPositionedModel?.toJson(),
    };
