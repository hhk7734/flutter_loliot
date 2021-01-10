import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../react_grid_view.dart';

part 'react_grid_view_state.dart';

class ReactGridViewCubit extends Cubit<ReactGridViewState> {
  ReactGridViewCubit() : super(ReactGridViewInitial());

  List<ReactPositioned> _children;
  set children(List<ReactPositioned> children) => _children = children;

  ReactGridViewModel _reactGridViewModel;
  set reactGridViewModel(ReactGridViewModel model) =>
      _reactGridViewModel = model;

  set width(double width) =>
      _reactGridViewModel = _reactGridViewModel.copyWith(width: width);

  void initView() {
    emit(ReactGridViewUpdateState(_children, _reactGridViewModel));
  }
}
