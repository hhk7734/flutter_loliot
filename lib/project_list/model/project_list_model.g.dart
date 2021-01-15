// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectListModel _$ProjectListModelFromJson(Map<String, dynamic> json) {
  return ProjectListModel(
    projectNameSet:
        (json['projectNameSet'] as List)?.map((e) => e as String)?.toSet(),
    reactGridViewModel: json['reactGridViewModel'] == null
        ? null
        : ReactGridViewModel.fromJson(
            json['reactGridViewModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectListModelToJson(ProjectListModel instance) =>
    <String, dynamic>{
      'projectNameSet': instance.projectNameSet?.toList(),
      'reactGridViewModel': instance.reactGridViewModel?.toJson(),
    };
