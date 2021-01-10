// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'react_grid_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactGridViewModel _$ReactGridViewModelFromJson(Map<String, dynamic> json) {
  return ReactGridViewModel(
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
      'clickableWidth': instance.clickableWidth,
      'crossAxisCount': instance.crossAxisCount,
      'crossAxisSpacing': instance.crossAxisSpacing,
      'gridAspectRatio': instance.gridAspectRatio,
      'mainAxisCount': instance.mainAxisCount,
      'mainAxisSpacing': instance.mainAxisSpacing,
    };
