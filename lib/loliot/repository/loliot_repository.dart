import 'package:react_grid_view/react_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../project/project.dart';
import '../../project_list/project_list.dart';

const String kProjectListModelKey = "loliot_project_list_model";
const String kProjectKeyPrefix = "loliot_project_name_";

class LoliotRepository {
  SharedPreferences _prefs;

  ProjectListModel projectListModel;

  Map<String, ProjectModel> projectModelMap;

  Map<int, String> projectNameMap = {};

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

    projectModelMap = Map.fromIterable(
      projectListModel.projectNameSet,
      key: (e) => e,
      value: (e) =>
          ProjectModel.fromString(_prefs.getString(kProjectKeyPrefix + e)),
    );
  }

  void addProject(ProjectModel projectModel) {
    projectListModel.projectNameSet.add(projectModel.name);
    projectModelMap.putIfAbsent(projectModel.name, () => projectModel);
    projectNameMap.putIfAbsent(
        projectModel.reactPositioned.index, () => projectModel.name);

    _prefs.setString(kProjectListModelKey, projectListModel.toString());
    _prefs.setString(
        kProjectKeyPrefix + projectModel.name, projectModel.toString());
  }

  void addProjectItem(String projectName, ProjectItemModel projectItemModel) {
    projectModelMap[projectName].projectItemModelList.add(projectItemModel);

    _prefs.setString(kProjectKeyPrefix + projectName,
        projectModelMap[projectName].toString());
  }

  void projectListRearrange(List<int> indexList) {
    if (!projectNameMap.keys.contains(indexList[0])) {
      projectModelMap.forEach((name, projectModel) {
        projectNameMap.putIfAbsent(
            projectModel.reactPositioned.index, () => name);
      });
    }

    indexList.forEach((index) {
      projectListModel.projectNameSet.remove(projectNameMap[index]);
    });

    indexList.forEach((index) {
      projectListModel.projectNameSet.add(projectNameMap[index]);
    });

    _prefs.setString(kProjectListModelKey, projectListModel.toString());
  }

  void saveProjectModel(String projectName) {
    _prefs.setString(kProjectKeyPrefix + projectName,
        projectModelMap[projectName].toString());
  }
}
