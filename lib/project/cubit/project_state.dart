part of 'project_cubit.dart';

enum ProjectStatus { loading, success }

class ProjectState extends Equatable {
  const ProjectState._({
    this.activate = false,
    this.status = ProjectStatus.loading,
    this.reactGridView,
  });

  const ProjectState.loading() : this._();

  const ProjectState.success(bool activate, ReactGridView reactGridView)
      : this._(
          activate: activate,
          status: ProjectStatus.success,
          reactGridView: reactGridView,
        );

  final bool activate;
  final ProjectStatus status;
  final ReactGridView reactGridView;

  @override
  List<Object> get props => [activate, status, reactGridView];
}
