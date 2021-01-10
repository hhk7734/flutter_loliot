import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../react_grid_view.dart';

class ReactGridView extends StatelessWidget {
  ReactGridView({
    Key key,
    List<ReactPositioned> children,
    double clickableWidth = 30,
    @required int crossAxisCount,
    double crossAxisSpacing = 10,
    double gridAspectRatio = 3 / 4,
    @required int mainAxisCount,
    double mainAxisSpacing = 10,
  }) : super(key: key) {
    _cubit.children = children ?? <ReactPositioned>[];
    _cubit.reactGridViewModel = ReactGridViewModel(
      clickableWidth: clickableWidth,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      gridAspectRatio: gridAspectRatio,
      mainAxisCount: mainAxisCount,
      mainAxisSpacing: mainAxisSpacing,
    );
  }

  final ReactGridViewCubit _cubit = ReactGridViewCubit();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _cubit.width = constraints.maxWidth;
        return BlocProvider(
          create: (_) => _cubit,
          child: SingleChildScrollView(
            child: BlocBuilder<ReactGridViewCubit, ReactGridViewState>(
              cubit: _cubit..initView(),
              buildWhen: (previous, current) {
                if (current is ReactGridViewUpdateState) return true;
                return false;
              },
              builder: (context, state) {
                if (state is ReactGridViewUpdateState) {
                  double height = constraints.maxHeight > state.model.height
                      ? constraints.maxHeight
                      : state.model.height;
                  return GestureDetector(
                    child: Container(
                      height: height,
                      child: Stack(children: state.children),
                    ),
                  );
                }
                return Container(
                  child: const Center(child: CircularProgressIndicator()),
                  height: constraints.maxHeight,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
