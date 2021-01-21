// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectItemModel _$ProjectItemModelFromJson(Map<String, dynamic> json) {
  return ProjectItemModel(
    projectItemType:
        _$enumDecodeNullable(_$ProjectItemTypeEnumMap, json['projectItemType']),
    reactPositionedModel: json['reactPositionedModel'] == null
        ? null
        : ReactPositionedModel.fromJson(
            json['reactPositionedModel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectItemModelToJson(ProjectItemModel instance) =>
    <String, dynamic>{
      'projectItemType': _$ProjectItemTypeEnumMap[instance.projectItemType],
      'reactPositionedModel': instance.reactPositionedModel?.toJson(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ProjectItemTypeEnumMap = {
  ProjectItemType.button: 'button',
  ProjectItemType.horizontalSlider: 'horizontalSlider',
  ProjectItemType.joystick: 'joystick',
  ProjectItemType.verticalSlider: 'verticalSlider',
};
