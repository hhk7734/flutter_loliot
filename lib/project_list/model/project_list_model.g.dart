// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectListModel _$ProjectListModelFromJson(Map<String, dynamic> json) {
  return ProjectListModel(
    projectNameList:
        (json['projectNameList'] as List)?.map((e) => e as String)?.toList(),
    reactGridViewModel: json['reactGridViewModel'] == null
        ? null
        : ReactGridViewModel.fromJson(
            json['reactGridViewModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectListModelToJson(ProjectListModel instance) =>
    <String, dynamic>{
      'projectNameList': instance.projectNameList,
      'reactGridViewModel': instance.reactGridViewModel?.toJson(),
    };
