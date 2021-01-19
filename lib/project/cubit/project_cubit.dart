import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../project.dart';
import '../../loliot/loliot.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit({
    @required LoliotRepository loliotRepository,
    @required this.name,
  })  : _loliotRepository = loliotRepository,
        super(ProjectState.loading());

  final LoliotRepository _loliotRepository;
  final String name;
  ReactGridView _reactGridView;

  void initView() {
    ProjectModel model = _loliotRepository.projectModelMap[name];
    _reactGridView = ReactGridView.fromModel(
      children: model.projectItemList
          .map<ReactPositioned>((e) => e.toWidget())
          .toList(),
      model: _loliotRepository.projectModelMap[name].reactGridViewModel,
    );
    emit(ProjectState.success(_reactGridView));
  }
}
