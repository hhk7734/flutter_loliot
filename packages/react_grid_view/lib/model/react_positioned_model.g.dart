// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'react_positioned_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactPositionedModel _$ReactPositionedModelFromJson(Map<String, dynamic> json) {
  return ReactPositionedModel(
    crossAxisCount: json['crossAxisCount'] as int,
    crossAxisOffsetCount: json['crossAxisOffsetCount'] as int,
    horizontalResizable: json['horizontalResizable'] as bool,
    mainAxisCount: json['mainAxisCount'] as int,
    mainAxisOffsetCount: json['mainAxisOffsetCount'] as int,
    maxCrossAxisCount: json['maxCrossAxisCount'] as int,
    maxMainAxisCount: json['maxMainAxisCount'] as int,
    minCrossAxisCount: json['minCrossAxisCount'] as int,
    minMainAxisCount: json['minMainAxisCount'] as int,
    movable: json['movable'] as bool,
    verticalResizable: json['verticalResizable'] as bool,
  );
}

Map<String, dynamic> _$ReactPositionedModelToJson(
        ReactPositionedModel instance) =>
    <String, dynamic>{
      'crossAxisCount': instance.crossAxisCount,
      'crossAxisOffsetCount': instance.crossAxisOffsetCount,
      'horizontalResizable': instance.horizontalResizable,
      'mainAxisCount': instance.mainAxisCount,
      'mainAxisOffsetCount': instance.mainAxisOffsetCount,
      'maxCrossAxisCount': instance.maxCrossAxisCount,
      'maxMainAxisCount': instance.maxMainAxisCount,
      'minCrossAxisCount': instance.minCrossAxisCount,
      'minMainAxisCount': instance.minMainAxisCount,
      'movable': instance.movable,
      'verticalResizable': instance.verticalResizable,
    };
