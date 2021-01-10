import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../react_grid_view.dart';

part 'react_grid_view_state.dart';

class ReactGridViewCubit extends Cubit<ReactGridViewState> {
  ReactGridViewCubit(List<ReactPositioned> children, ReactGridViewModel model)
      : _children = children.asMap(),
        _reactGridViewModel = model,
        super(ReactGridViewInitial());

  Map<int, ReactPositioned> _children;

  ReactGridViewModel _reactGridViewModel;

  set width(double width) =>
      _reactGridViewModel = _reactGridViewModel.copyWith(width: width);

  void initView() {
    emit(ReactGridViewUpdateState(
        _children.entries.map((e) => e.value).toList(), _reactGridViewModel));
  }
}
