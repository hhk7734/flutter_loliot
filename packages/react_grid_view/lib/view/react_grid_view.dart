import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../react_grid_view.dart';

class ReactGridView extends StatelessWidget {
  ReactGridView({
    Key key,
    ReactGridViewAlignment alignment = ReactGridViewAlignment.none,
    List<ReactPositioned> children,
    double clickableWidth = 30,
    @required int crossAxisCount,
    double crossAxisSpacing = 10,
    double gridAspectRatio = 3 / 4,
    @required int mainAxisCount,
    double mainAxisSpacing = 10,
    ReactGridViewChildrenMoveEndCallback onChildrenMoveEnd,
    ReactGridViewChildResizeEndCallback onChildResizeEnd,
  })  : _cubit = ReactGridViewCubit(
          children: children,
          model: ReactGridViewModel(
            alignment: alignment,
            clickableWidth: clickableWidth,
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            gridAspectRatio: gridAspectRatio,
            mainAxisCount: mainAxisCount,
            mainAxisSpacing: mainAxisSpacing,
          ),
          onChildrenMoveEnd: onChildrenMoveEnd,
          onChildResizeEnd: onChildResizeEnd,
        ),
        super(key: key);

  ReactGridView.fromModel({
    Key key,
    List<ReactPositioned> children,
    ReactGridViewModel model,
    ReactGridViewChildrenMoveEndCallback onChildrenMoveEnd,
    ReactGridViewChildResizeEndCallback onChildResizeEnd,
  })  : _cubit = ReactGridViewCubit(
          children: children,
          model: model,
          onChildrenMoveEnd: onChildrenMoveEnd,
          onChildResizeEnd: onChildResizeEnd,
        ),
        super(key: key);

  final ReactGridViewCubit _cubit;

  Map<int, ReactPositioned> get children => _cubit.children;

  ReactGridViewModel get model => _cubit.model;

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
                  return Container(
                    color: Colors.transparent,
                    height: height,
                    child: Stack(children: state.children),
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

  void addChild({@required ReactPositioned child}) {
    _cubit.addChild(child);
  }

  void removeChild({@required int childIndex}) {
    _cubit.removeChild(childIndex);
  }

  void setEditable({@required bool editable}) {
    _cubit.setEditable(editable);
  }
}
