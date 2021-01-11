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

  void _addChild(ReactPositioned child) {
    assert(
        !_children.entries.any((e) => e.value.model.checkOverlap(child.model)));
    assert(!_model.checkOverflow(child.model));

    int index = _children.isEmpty ? 0 : _children.keys.last + 1;
    child.index = index;
    _children.putIfAbsent(index, () => child);
  }

  void addChild(ReactPositioned child) {
    _addChild(child);
    emit(ReactGridViewUpdateState(
        _children.entries.map((e) => e.value.toWidget()).toList(), _model));
  }

  void initView() {
    emit(ReactGridViewUpdateState(
        _children.entries.map((e) => e.value.toWidget()).toList(), _model));
  }
}
