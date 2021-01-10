import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'react_grid_view_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReactGridViewModel extends Equatable {
  const ReactGridViewModel({
    @required this.crossAxisCount,
    this.crossAxisSpacing = 10,
    this.gridAspectRatio = 3 / 4,
    @required this.mainAxisCount,
    this.mainAxisSpacing = 10,
    this.width = 0,
  })  : assert(crossAxisCount != null && crossAxisSpacing != null,
            gridAspectRatio != null && mainAxisCount != null),
        crossAxisStride = width / crossAxisCount,
        height = mainAxisCount * width / crossAxisCount / gridAspectRatio,
        mainAxisStride = width / crossAxisCount / gridAspectRatio;

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
