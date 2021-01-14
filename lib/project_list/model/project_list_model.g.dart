// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectListModel _$ProjectListModelFromJson(Map<String, dynamic> json) {
  return ProjectListModel(
    projectModelList: (json['projectModelList'] as List)
        ?.map((e) =>
            e == null ? null : ProjectModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    reactGridViewModel: json['reactGridViewModel'] == null
        ? null
        : ReactGridViewModel.fromJson(
            json['reactGridViewModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectListModelToJson(ProjectListModel instance) =>
    <String, dynamic>{
      'projectModelList':
          instance.projectModelList?.map((e) => e?.toJson())?.toList(),
      'reactGridViewModel': instance.reactGridViewModel?.toJson(),
    };
