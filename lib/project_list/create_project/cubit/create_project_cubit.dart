import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../create_project.dart';
import '../../project_list.dart';

part 'create_project_state.dart';

class CreateProjectCubit extends Cubit<CreateProjectState> {
  CreateProjectCubit({
    @required this.projectRepository,
  }) : super(CreateProjectState());

  final ProjectRepository projectRepository;

  void projectNameChanged(String value) {
    final projectName = ProjectName.dirty(
      projectNameSet: projectRepository.projectListModel.projectNameSet,
      value: value,
    );

    emit(state.copyWith(
      projectName: projectName,
      status: Formz.validate([projectName]),
    ));
  }

  void create(String name) {
    projectRepository.createProject(name);
  }
}
