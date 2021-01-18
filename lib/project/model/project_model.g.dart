// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return ProjectModel(
    name: json['name'] as String,
    projectItemList: (json['projectItemList'] as List)
        ?.map((e) =>
            e == null ? null : ProjectItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    reactGridViewModel: json['reactGridViewModel'] == null
        ? null
        : ReactGridViewModel.fromJson(
            json['reactGridViewModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectItemList':
          instance.projectItemList?.map((e) => e?.toJson())?.toList(),
      'reactGridViewModel': instance.reactGridViewModel?.toJson(),
    };
