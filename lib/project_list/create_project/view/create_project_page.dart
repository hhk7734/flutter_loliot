import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../create_project.dart';
import '../../project/project.dart';
import '../../project_list.dart';

class CreateProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateProjectCubit>(
      create: (context) => CreateProjectCubit(
          projectRepository: context.read<ProjectRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Project"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16.0),
            _ProjectNameInput(),
            const SizedBox(height: 4.0),
            _CreateButton(),
          ],
        ),
      ),
    );
  }

  static Route route() {
    return MaterialPageRoute<ProjectModel>(builder: (_) => CreateProjectPage());
  }
}

class _ProjectNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProjectCubit, CreateProjectState>(
      buildWhen: (previous, current) =>
          previous.projectName != current.projectName,
      builder: (context, state) => TextField(
        onChanged: (projectName) =>
            context.read<CreateProjectCubit>().projectNameChanged(projectName),
        decoration: InputDecoration(
          labelText: 'project name',
          helperText: '',
          errorText: _getErrorText(state),
        ),
      ),
    );
  }

  String _getErrorText(CreateProjectState state) {
    switch (state.projectName.error) {
      case ProjectNameValidationError.alreadyExist:
        return 'already exist';
      case ProjectNameValidationError.invalid:
        return 'invalid name';
      default:
        return null;
    }
  }
}

class _CreateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProjectCubit, CreateProjectState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return FlatButton(
          child: Text("create"),
          onPressed: state.status.isValidated
              ? () {
                  Navigator.of(context).pop(context
                      .read<CreateProjectCubit>()
                      .create(state.projectName.value));
                }
              : null,
        );
      },
    );
  }
}
