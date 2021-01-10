import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../react_grid_view.dart';

part 'react_grid_view_state.dart';

class ReactGridViewCubit extends Cubit<ReactGridViewState> {
  ReactGridViewCubit(List<ReactPositioned> children, ReactGridViewModel model)
      : _children = children.asMap(),
        _model = model,
        super(ReactGridViewInitial()) {
    _childrenModel = <int, ReactPositionedModel>{};
    _children.forEach((int index, ReactPositioned child) {
      ReactPositionedModel reactPositionedModel = ReactPositionedModel(
        crossAxisCount: child.crossAxisCount,
        crossAxisOffsetCount: child.crossAxisOffsetCount,
        horizontalResizable: child.horizontalResizable,
        mainAxisCount: child.mainAxisCount,
        mainAxisOffsetCount: child.mainAxisOffsetCount,
        maxCrossAxisCount: child.maxCrossAxisCount,
        maxMainAxisCount: child.maxMainAxisCount,
        minCrossAxisCount: child.minCrossAxisCount,
        minMainAxisCount: child.minMainAxisCount,
        movable: child.movable,
        verticalResizable: child.verticalResizable,
      );

      assert(!_childrenModel.entries
          .any((e) => e.value.checkOverlap(reactPositionedModel)));
      assert(!_model.checkOverflow(reactPositionedModel));
      _childrenModel.putIfAbsent(index, () => reactPositionedModel);
    });
  }

  Map<int, ReactPositioned> _children;

  Map<int, ReactPositionedModel> _childrenModel;
  Map<int, ReactPositionedModel> get childrenModel => _childrenModel;

  ReactGridViewModel _model;

  set width(double width) {
    _model = _model.copyWith(width: width);
  }

  void initView() {
    emit(ReactGridViewUpdateState(
        _children.entries.map((e) => e.value).toList(), _model));
  }

  int findChildIndex(ReactPositioned child) {
    return _children.entries.firstWhere((e) {
      return e.value.crossAxisCount == child.crossAxisCount &&
          e.value.crossAxisOffsetCount == child.crossAxisOffsetCount &&
          e.value.horizontalResizable == child.horizontalResizable &&
          e.value.mainAxisCount == child.mainAxisCount &&
          e.value.mainAxisOffsetCount == child.mainAxisOffsetCount &&
          e.value.maxCrossAxisCount == child.maxCrossAxisCount &&
          e.value.maxMainAxisCount == child.maxMainAxisCount &&
          e.value.minCrossAxisCount == child.minCrossAxisCount &&
          e.value.minMainAxisCount == child.minMainAxisCount &&
          e.value.movable == child.movable &&
          e.value.verticalResizable == child.verticalResizable;
    }).key;
  }
}
