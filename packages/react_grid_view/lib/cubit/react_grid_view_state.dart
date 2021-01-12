part of 'react_grid_view_cubit.dart';

abstract class ReactGridViewState extends Equatable {
  const ReactGridViewState();
}

class ReactGridViewInitial extends ReactGridViewState {
  @override
  List<Object> get props => [];
}

class ReactGridViewUpdateState extends ReactGridViewState {
  const ReactGridViewUpdateState(this.children, this.model);

  final List<Widget> children;
  final ReactGridViewModel model;

  @override
  List<Object> get props => [children.length, model];
}

class ReactPositionedUpdateState extends ReactGridViewState {
  const ReactPositionedUpdateState(this.indexList);

  final List<int> indexList;

  @override
  List<Object> get props => [DateTime.now()];
}

class ReactPositionedCloseOvelayState extends ReactGridViewState {
  @override
  List<Object> get props => [DateTime.now()];
}
