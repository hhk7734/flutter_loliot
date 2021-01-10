import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../react_grid_view.dart';

class ReactPositioned extends StatefulWidget {
  ReactPositioned({
    Key key,
    this.child,
    this.crossAxisCount = 1,
    this.crossAxisOffsetCount = 0,
    this.horizontalResizable = true,
    this.mainAxisCount = 1,
    this.mainAxisOffsetCount = 0,
    this.maxCrossAxisCount = 1,
    this.maxMainAxisCount = 1,
    this.minCrossAxisCount = 1,
    this.minMainAxisCount = 1,
    this.movable = true,
    this.verticalResizable = true,
  }) : super(key: key ?? UniqueKey());

  final Widget child;

  final int crossAxisCount;
  final int crossAxisOffsetCount;

  final bool horizontalResizable;

  final int mainAxisCount;
  final int mainAxisOffsetCount;

  final int maxCrossAxisCount;
  final int maxMainAxisCount;

  final int minCrossAxisCount;
  final int minMainAxisCount;

  final bool movable;

  final bool verticalResizable;

  @override
  _ReactPositionedState createState() => _ReactPositionedState();
}

class _ReactPositionedState extends State<ReactPositioned> {
  ReactGridViewCubit _cubit;

  double get crossAxisOverflow => reactGridViewModel.crossAxisSpacing >
          reactGridViewModel.clickableWidth
      ? 0
      : reactGridViewModel.clickableWidth - reactGridViewModel.crossAxisSpacing;

  double get height =>
      model.mainAxisCount * reactGridViewModel.mainAxisStride +
      mainAxisOverflow;

  double get heightWithoutMargin => height - margin.vertical;

  int index;

  double get left =>
      model.crossAxisOffsetCount * reactGridViewModel.crossAxisStride -
      crossAxisOverflow / 2;

  double get mainAxisOverflow => reactGridViewModel.mainAxisSpacing >
          reactGridViewModel.clickableWidth
      ? 0
      : reactGridViewModel.clickableWidth - reactGridViewModel.mainAxisSpacing;

  EdgeInsets get margin {
    double cross =
        (reactGridViewModel.crossAxisSpacing + crossAxisOverflow) / 2;
    double main = (reactGridViewModel.mainAxisSpacing + mainAxisOverflow) / 2;
    return EdgeInsets.fromLTRB(cross, main, cross, main);
  }

  ReactPositionedModel model;

  ReactGridViewModel reactGridViewModel;

  double get top =>
      model.mainAxisOffsetCount * reactGridViewModel.mainAxisStride -
      mainAxisOverflow / 2;

  double get width =>
      model.crossAxisCount * reactGridViewModel.crossAxisStride +
      crossAxisOverflow;

  double get widthWithoutMargin => width - margin.horizontal;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ReactGridViewCubit>();
    index = _cubit.findChildIndex(widget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReactGridViewCubit, ReactGridViewState>(
      cubit: _cubit,
      buildWhen: (previous, current) {
        if (current is ReactPositionedUpdateState) {
          if (current.childrenModel.containsKey(index)) return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is ReactGridViewUpdateState) {
          model = _cubit.childrenModel[index];
          reactGridViewModel = state.model;
        } else if (state is ReactPositionedUpdateState) {
          model = state.childrenModel[index];
          reactGridViewModel = state.model;
        }

        return Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            child: model.movable
                ? LongPressDraggable(
                    child: Container(
                      child: widget.child,
                      height: heightWithoutMargin,
                      margin: margin,
                      width: widthWithoutMargin,
                    ),
                    childWhenDragging: Container(
                      color: Color.fromRGBO(0, 100, 0, 0.2),
                      height: heightWithoutMargin,
                      margin: margin,
                      width: widthWithoutMargin,
                    ),
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        child: Transform.scale(
                          child: widget.child,
                          scale: 1.05,
                        ),
                        height: heightWithoutMargin,
                        margin: margin,
                        width: widthWithoutMargin,
                      ),
                    ),
                  )
                : Container(
                    child: widget.child,
                    height: heightWithoutMargin,
                    margin: margin,
                    width: widthWithoutMargin,
                  ),
          ),
        );
      },
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {},
    );
  }
}
