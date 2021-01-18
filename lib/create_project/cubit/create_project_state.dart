part of 'create_project_cubit.dart';

class CreateProjectState extends Equatable {
  const CreateProjectState({
    this.projectName = const ProjectName.pure(),
    this.status = FormzStatus.pure,
  });

  final ProjectName projectName;
  final FormzStatus status;

  @override
  List<Object> get props => [projectName, status];

  CreateProjectState copyWith({
    ProjectName projectName,
    FormzStatus status,
  }) =>
      CreateProjectState(
        projectName: projectName ?? this.projectName,
        status: status ?? this.status,
      );
}
