import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:react_grid_view/react_grid_view.dart';

import '../../create_project/create_project.dart';
import '../../loliot/loliot.dart';

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
      children: _loliotRepository.projectModelList
          .map<ReactPositioned>((e) => e.toAvatar(context))
          .toList(),
      model: _loliotRepository.projectListModel.reactGridViewModel,
      onChildrenMove: _loliotRepository.projectListRearrange,
    );
    emit(ProjectListState.success(_reactGridView));
  }

  void createProject(BuildContext context) {
    Navigator.of(context).push<bool>(CreateProjectPage.route()).then((value) {
      if (value != null && value) {
        _reactGridView.addChild(
            child: _loliotRepository.projectModelList.last.toAvatar(context));
      }
    });
  }
}
