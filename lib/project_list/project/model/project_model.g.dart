// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return ProjectModel(
    reactGridViewModel: json['reactGridViewModel'] == null
        ? null
        : ReactGridViewModel.fromJson(
            json['reactGridViewModel'] as Map<String, dynamic>),
    reactPositionedModel: json['reactPositionedModel'] == null
        ? null
        : ReactPositionedModel.fromJson(
            json['reactPositionedModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'reactGridViewModel': instance.reactGridViewModel?.toJson(),
      'reactPositionedModel': instance.reactPositionedModel?.toJson(),
    };