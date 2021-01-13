import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../react_grid_view.dart';

part 'react_grid_view_state.dart';

class ReactGridViewCubit extends Cubit<ReactGridViewState> {
  ReactGridViewCubit(List<ReactPositioned> children, ReactGridViewModel model)
      : _model = model,
        super(ReactGridViewInitial()) {
    children.forEach((e) => _addChild(e));
  }

  final Map<int, ReactPositioned> _children = <int, ReactPositioned>{};
  Map<int, ReactPositioned> get children => _children;

  ReactGridViewModel _model;
  ReactGridViewModel get model => _model;

  set width(double width) {
    _model = _model.copyWith(width: width);
  }

  bool _addChild(ReactPositioned child) {
    if (_checkOverlap(-1, child.model)) return false;
    if (_model.checkOverflow(child.model)) return false;

    int index = _children.isEmpty ? 0 : _children.keys.last + 1;
    child.index = index;
    _children.putIfAbsent(index, () => child);
    return true;
  }

  bool addChild(ReactPositioned child) {
    int maxCrossAxisOffsetCount =
        _model.crossAxisCount - child.model.crossAxisCount;
    int maxMainAxisOffsetCount =
        _model.mainAxisCount - child.model.mainAxisCount;
    if (maxCrossAxisOffsetCount < 0 || maxMainAxisOffsetCount < 0) return false;

    for (int i = 0; i <= maxMainAxisOffsetCount; i++) {
      for (int j = 0; j <= maxCrossAxisOffsetCount; j++) {
        child.model = child.model
            .copyWith(crossAxisOffsetCount: j, mainAxisOffsetCount: i);
        if (_addChild(child)) {
          emit(ReactGridViewUpdateState(
              _children.entries.map((e) => e.value.toWidget()).toList(),
              _model));
          return true;
        }
      }
    }

    return false;
  }

  bool _checkOverlap(int excludedIndex, ReactPositionedModel model) {
    return _children.entries.any((e) {
      if (e.key == excludedIndex) return false;
      return e.value.model.checkOverlap(model);
    });
  }

  void closeResizableOverlay() {
    emit(ReactPositionedCloseOvelayState());
  }

  void initView() {
    emit(ReactGridViewUpdateState(
        _children.entries.map((e) => e.value.toWidget()).toList(), _model));
  }

  void movedChild(int index, ReactPositionedModel model) {
    List<int> indexList = [];

    switch (_model.alignment) {
      case ReactGridViewAlignment.none:
        if (_checkOverlap(index, model)) return;
        _children[index].model = model;
        indexList.add(index);
        break;
      case ReactGridViewAlignment.sequential:
        break;
    }

    if (indexList.length > 0) emit(ReactPositionedUpdateState(indexList));
  }

  void resizedChild(int index, ReactPositionedModel model) {
    List<int> indexList = [];

    switch (_model.alignment) {
      case ReactGridViewAlignment.none:
        if (_checkOverlap(index, model)) return;
        _children[index].model = model;
        indexList.add(index);
        break;
      case ReactGridViewAlignment.sequential:
        break;
    }

    if (indexList.length > 0) emit(ReactPositionedUpdateState(indexList));
  }
}
