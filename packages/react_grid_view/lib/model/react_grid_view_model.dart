import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'react_grid_view_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReactGridViewModel extends Equatable {
  const ReactGridViewModel({
    this.clickableWidth = 30,
    @required this.crossAxisCount,
    this.crossAxisSpacing = 10,
    this.gridAspectRatio = 3 / 4,
    @required this.mainAxisCount,
    this.mainAxisSpacing = 10,
    this.width = 1,
  })  : assert(clickableWidth > 0 &&
            crossAxisCount > 1 &&
            crossAxisSpacing >= 0 &&
            gridAspectRatio > 0 &&
            mainAxisCount > 1 &&
            mainAxisSpacing >= 0 &&
            width > 0),
        crossAxisStride = width / crossAxisCount,
        height = mainAxisCount * width / crossAxisCount / gridAspectRatio,
        mainAxisStride = width / crossAxisCount / gridAspectRatio;

  final double clickableWidth;

  final int crossAxisCount;
  final double crossAxisSpacing;
  @JsonKey(ignore: true)
  final double crossAxisStride;

  final double gridAspectRatio;

  @JsonKey(ignore: true)
  final double height;

  final int mainAxisCount;
  final double mainAxisSpacing;
  @JsonKey(ignore: true)
  final double mainAxisStride;

  @JsonKey(ignore: true)
  final double width;

  // Equatable

  ReactGridViewModel copyWith({
    int crossAxisCount,
    double crossAxisSpacing,
    double gridAspectRatio,
    int mainAxisCount,
    double mainAxisSpacing,
    double width,
  }) =>
      ReactGridViewModel(
        crossAxisCount: crossAxisCount ?? this.crossAxisCount,
        crossAxisSpacing: crossAxisSpacing ?? this.crossAxisSpacing,
        gridAspectRatio: gridAspectRatio ?? this.gridAspectRatio,
        mainAxisCount: mainAxisCount ?? this.mainAxisCount,
        mainAxisSpacing: mainAxisSpacing ?? this.mainAxisSpacing,
        width: width ?? this.width,
      );

  @override
  List<Object> get props => [
        crossAxisCount,
        crossAxisSpacing,
        gridAspectRatio,
        mainAxisCount,
        mainAxisSpacing,
        width
      ];

  // JsonSerializable

  factory ReactGridViewModel.fromJson(Map<String, dynamic> json) =>
      _$ReactGridViewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReactGridViewModelToJson(this);
}
