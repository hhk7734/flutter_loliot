import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../../create_project/create_project.dart';
import '../../loliot/loliot.dart';
import '../../project/project.dart';

part 'project_list_state.dart';

class ProjectListCubit extends Cubit<ProjectListState> {
  ProjectListCubit({
    @required LoliotRepository loliotRepository,
  })  : _loliotRepository = loliotRepository,
        super(ProjectListState.loading());

  final LoliotRepository _loliotRepository;
  ReactGridView _reactGridView;

  void initView(BuildContext context) {
    _reactGridView = ReactGridView.fromModel(
      children: _loliotRepository.projectModelMap.entries
          .map<ReactPositioned>((e) => e.value.toAvatar(context))
          .toList(),
      model: _loliotRepository.projectListModel.reactGridViewModel,
      onChildrenMoveEnd: _loliotRepository.projectListRearrange,
    );
    emit(ProjectListState.success(_reactGridView));
  }

  void createProject(BuildContext context) {
    Navigator.of(context)
        .push<ProjectModel>(CreateProjectPage.route())
        .then((projectModel) {
      if (projectModel != null) {
        _reactGridView.addChild(child: projectModel.toAvatar(context));
        _loliotRepository.addProject(projectModel);
      }
    });
  }
}
