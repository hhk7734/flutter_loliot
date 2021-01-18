import 'package:react_grid_view/react_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../project/project.dart';
import '../../project_list/project_list.dart';

const String kProjectListModelKey = "loliot_project_list_model";
const String kProjectKeyPrefix = "loliot_project_name_";

class LoliotRepository {
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
        .map<ProjectModel>((key) =>
            ProjectModel.fromString(_prefs.getString(kProjectKeyPrefix + key)))
        .toList();
  }

  void createProject(String name) {
    ProjectModel projectModel = ProjectModel(
      name: name,
      reactGridViewModel: ReactGridViewModel(
        alignment: ReactGridViewAlignment.none,
        crossAxisCount: 8,
        mainAxisCount: 12,
      ),
    );

    projectListModel.projectNameSet.add(name);
    projectModelList.add(projectModel);

    _prefs.setString(kProjectListModelKey, projectListModel.toString());
    _prefs.setString(
        kProjectKeyPrefix + projectModel.name, projectModel.toString());
  }
}
