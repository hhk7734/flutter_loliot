part of 'project_list_cubit.dart';

enum ProjectListStatus { loading, success }

class ProjectListState extends Equatable {
  const ProjectListState._({
    this.status = ProjectListStatus.loading,
    this.reactGridView,
  });

  const ProjectListState.loading() : this._();

  const ProjectListState.success(ReactGridView reactGridView)
      : this._(
          status: ProjectListStatus.success,
          reactGridView: reactGridView,
        );

  final ProjectListStatus status;
  final ReactGridView reactGridView;

  @override
  List<Object> get props => [status];
}
