part of 'project_cubit.dart';

enum ProjectStatus { loading, success }

class ProjectState extends Equatable {
  const ProjectState._({
    this.status = ProjectStatus.loading,
    this.reactGridView,
  });

  const ProjectState.loading() : this._();

  const ProjectState.success(ReactGridView reactGridView)
      : this._(
          status: ProjectStatus.success,
          reactGridView: reactGridView,
        );

  final ProjectStatus status;
  final ReactGridView reactGridView;

  @override
  List<Object> get props => [status, reactGridView];
}
