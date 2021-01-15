import 'package:react_grid_view/react_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../project/project.dart';
import '../project_list.dart';

const String kProjectListModelKey = "loliot_project_list_model";

class ProjectRepository {
  SharedPreferences _prefs;

  ProjectListModel projectListModel;

  List<ProjectModel> projectModelList;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    String projectListModelString = _prefs.getString(kProjectListModelKey);
    if (projectListModelString != null) {
      projectListModel = ProjectListModel.fromString(projectListModelString);
    } else {
      projectListModel = ProjectListModel(
        reactGridViewModel: ReactGridViewModel(
          alignment: ReactGridViewAlignment.sequential,
          crossAxisCount: 2,
          mainAxisCount: 6,
        ),
      );

      _prefs.setString(kProjectListModelKey, projectListModel.toString());
    }

    projectModelList = projectListModel.projectNameSet
        .map<ProjectModel>(
            (key) => ProjectModel.fromString(_prefs.getString(key)))
        .toList();
  }
}
