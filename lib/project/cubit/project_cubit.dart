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
      children: model.projectItemModelList.map<ReactPositioned>((e) {
        e.cubit = this;
        return e.toWidget();
      }).toList(),
      model: _loliotRepository.projectModelMap[name].reactGridViewModel,
      onChildrenMoveEnd: _onChildrenMoveEndCallback,
      onChildResizeEnd: _onChildResizeEndCallback,
    );
    emit(ProjectState.success(false, _reactGridView));
  }

  void addProjectItem(ProjectItemModel projectItemModel) {
    projectItemModel.cubit = this;
    _reactGridView.addChild(child: projectItemModel.toWidget());
    _loliotRepository.addProjectItem(name, projectItemModel);
  }

  void _onChildrenMoveEndCallback(List<int> indexList) {
    _loliotRepository.saveProjectModel(name);
  }

  void _onChildResizeEndCallback(List<int> indexList) {
    _loliotRepository.saveProjectModel(name);
  }

  void setActivate(bool activate) {
    _reactGridView.setEditable(editable: !activate);
    emit(ProjectState.success(activate, _reactGridView));
  }
}
