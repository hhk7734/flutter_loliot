import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'react_positioned_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReactPositionedModel extends Equatable {
  const ReactPositionedModel({
    this.crossAxisCount = 1,
    this.crossAxisOffsetCount = 0,
    this.horizontalResizable = true,
    this.mainAxisCount = 1,
    this.mainAxisOffsetCount = 0,
    this.maxCrossAxisCount = 1,
    this.maxMainAxisCount = 1,
    this.minCrossAxisCount = 1,
    this.minMainAxisCount = 1,
    this.movable = true,
    this.verticalResizable = true,
  })  : assert(crossAxisOffsetCount >= 0),
        assert(mainAxisOffsetCount >= 0),
        assert(minCrossAxisCount > 0),
        assert(minMainAxisCount > 0),
        assert(minCrossAxisCount <= crossAxisCount &&
            crossAxisCount <= maxCrossAxisCount),
        assert(minMainAxisCount <= mainAxisCount &&
            mainAxisCount <= maxMainAxisCount);

  final int crossAxisCount;
  final int crossAxisOffsetCount;

  final bool horizontalResizable;

  final int mainAxisCount;
  final int mainAxisOffsetCount;

  final int maxCrossAxisCount;
  final int maxMainAxisCount;

  final int minCrossAxisCount;
  final int minMainAxisCount;

  final bool movable;

  final bool verticalResizable;

  bool checkOverlap(ReactPositionedModel model) {
    int innerTop = mainAxisOffsetCount > model.mainAxisOffsetCount
        ? mainAxisOffsetCount
        : model.mainAxisOffsetCount;
    int innerBottom = mainAxisOffsetCount + mainAxisCount <
            model.mainAxisOffsetCount + model.mainAxisCount
        ? mainAxisOffsetCount + mainAxisCount
        : model.mainAxisOffsetCount + model.mainAxisCount;

    if (innerTop >= innerBottom) return false;

    int innerLeft = crossAxisOffsetCount > model.crossAxisOffsetCount
        ? crossAxisOffsetCount
        : model.crossAxisOffsetCount;
    int innerRight = crossAxisOffsetCount + crossAxisCount <
            model.crossAxisOffsetCount + model.crossAxisCount
        ? crossAxisOffsetCount + crossAxisCount
        : model.crossAxisOffsetCount + model.crossAxisCount;

    if (innerLeft >= innerRight) return false;

    return true;
  }

  // Equatable

  ReactPositionedModel copyWith({
    int crossAxisCount,
    int crossAxisOffsetCount,
    bool horizontalResizable,
    int mainAxisCount,
    int mainAxisOffsetCount,
    int maxCrossAxisCount,
    int maxMainAxisCount,
    int minCrossAxisCount,
    int minMainAxisCount,
    bool movable,
    bool verticalResizable,
  }) =>
      ReactPositionedModel(
        crossAxisCount: crossAxisCount ?? this.crossAxisCount,
        crossAxisOffsetCount: crossAxisOffsetCount ?? this.crossAxisOffsetCount,
        horizontalResizable: horizontalResizable ?? this.horizontalResizable,
        mainAxisCount: mainAxisCount ?? this.mainAxisCount,
        mainAxisOffsetCount: mainAxisOffsetCount ?? this.mainAxisOffsetCount,
        maxCrossAxisCount: maxCrossAxisCount ?? this.maxCrossAxisCount,
        maxMainAxisCount: maxMainAxisCount ?? this.maxMainAxisCount,
        minCrossAxisCount: minCrossAxisCount ?? this.minCrossAxisCount,
        minMainAxisCount: minMainAxisCount ?? this.minMainAxisCount,
        movable: movable ?? this.movable,
        verticalResizable: verticalResizable ?? this.verticalResizable,
      );

  @override
  List<Object> get props => [
        crossAxisCount,
        crossAxisOffsetCount,
        horizontalResizable,
        mainAxisCount,
        mainAxisOffsetCount,
        maxCrossAxisCount,
        maxMainAxisCount,
        minCrossAxisCount,
        minMainAxisCount,
        movable,
        verticalResizable
      ];

  // JsonSerializable

  factory ReactPositionedModel.fromJson(Map<String, dynamic> json) =>
      _$ReactPositionedModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReactPositionedModelToJson(this);
}
