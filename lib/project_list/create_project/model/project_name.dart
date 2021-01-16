import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

enum ProjectNameValidationError { invalid, alreadyExist }

class ProjectName extends FormzInput<String, ProjectNameValidationError> {
  const ProjectName.pure({
    this.projectNameSet = const {},
  }) : super.pure('');
  const ProjectName.dirty({@required this.projectNameSet, String value = ''})
      : super.dirty(value);

  final Set<String> projectNameSet;

  static final _projectNameRegExp = RegExp(r'^[a-zA-Z]+\w+$');

  @override
  ProjectNameValidationError validator(String value) {
    if (pure) return null;
    if (_projectNameRegExp.hasMatch(value)) {
      if (!projectNameSet.contains(value)) return null;
      return ProjectNameValidationError.alreadyExist;
    }
    return ProjectNameValidationError.invalid;
  }
}
