// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'react_grid_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactGridViewModel _$ReactGridViewModelFromJson(Map<String, dynamic> json) {
  return ReactGridViewModel(
    alignment: _$enumDecodeNullable(
        _$ReactGridViewAlignmentEnumMap, json['alignment']),
    clickableWidth: (json['clickableWidth'] as num)?.toDouble(),
    crossAxisCount: json['crossAxisCount'] as int,
    crossAxisSpacing: (json['crossAxisSpacing'] as num)?.toDouble(),
    gridAspectRatio: (json['gridAspectRatio'] as num)?.toDouble(),
    mainAxisCount: json['mainAxisCount'] as int,
    mainAxisSpacing: (json['mainAxisSpacing'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ReactGridViewModelToJson(ReactGridViewModel instance) =>
    <String, dynamic>{
      'alignment': _$ReactGridViewAlignmentEnumMap[instance.alignment],
      'clickableWidth': instance.clickableWidth,
      'crossAxisCount': instance.crossAxisCount,
      'crossAxisSpacing': instance.crossAxisSpacing,
      'gridAspectRatio': instance.gridAspectRatio,
      'mainAxisCount': instance.mainAxisCount,
      'mainAxisSpacing': instance.mainAxisSpacing,
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

const _$ReactGridViewAlignmentEnumMap = {
  ReactGridViewAlignment.none: 'none',
  ReactGridViewAlignment.sequential: 'sequential',
};
