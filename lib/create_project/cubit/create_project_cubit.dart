import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../create_project.dart';
import '../../loliot/loliot.dart';

part 'create_project_state.dart';

class CreateProjectCubit extends Cubit<CreateProjectState> {
  CreateProjectCubit({
    @required this.loliotRepository,
  }) : super(CreateProjectState());

  final LoliotRepository loliotRepository;

  void projectNameChanged(String value) {
    final projectName = ProjectName.dirty(
      projectNameSet: loliotRepository.projectListModel.projectNameSet,
      value: value,
    );

    emit(state.copyWith(
      projectName: projectName,
      status: Formz.validate([projectName]),
    ));
  }

  void create(String name) {
    loliotRepository.createProject(name);
  }
}
