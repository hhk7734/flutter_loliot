import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../react_grid_view.dart';

class ReactPositioned {
  ReactPositioned({
    Key key,
    this.child,
    int crossAxisCount = 1,
    int crossAxisOffsetCount = 0,
    bool horizontalResizable = true,
    int mainAxisCount = 1,
    int mainAxisOffsetCount = 0,
    int maxCrossAxisCount = 1,
    int maxMainAxisCount = 1,
    int minCrossAxisCount = 1,
    int minMainAxisCount = 1,
    bool movable = true,
    bool verticalResizable = true,
  })  : this.key = key ?? UniqueKey(),
        model = ReactPositionedModel(
          crossAxisCount: crossAxisCount,
          crossAxisOffsetCount: crossAxisOffsetCount,
          horizontalResizable: horizontalResizable,
          mainAxisCount: mainAxisCount,
          mainAxisOffsetCount: mainAxisOffsetCount,
          maxCrossAxisCount: maxCrossAxisCount,
          maxMainAxisCount: maxMainAxisCount,
          minCrossAxisCount: minCrossAxisCount,
          minMainAxisCount: minMainAxisCount,
          movable: movable,
          verticalResizable: verticalResizable,
        );

  final Widget child;

  int index;

  final Key key;

  ReactPositionedModel model;

  _ReactPositioned toWidget() => _ReactPositioned(
        key: key,
        child: child,
        index: index,
        model: model,
      );
}

class _ReactPositioned extends StatefulWidget {
  _ReactPositioned({
    Key key,
    this.child,
    this.index,
    this.model,
  }) : super(key: key);
  final Widget child;

  final int index;

  final ReactPositionedModel model;

  @override
  _ReactPositionedState createState() => _ReactPositionedState();
}

class _ReactPositionedState extends State<_ReactPositioned> {
  ReactGridViewCubit _cubit;

  ReactPositionedModel model;

  ReactGridViewModel reactGridViewModel;

  Offset offset;

  int previousOffsetX = 0;
  int previousOffsetY = 0;

  int startOffsetX = 0;
  int startOffsetY = 0;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ReactGridViewCubit>();
  }

  @override
  Widget build(BuildContext context) {
    reactGridViewModel = _cubit.model;
    return BlocConsumer<ReactGridViewCubit, ReactGridViewState>(
      cubit: _cubit,
      buildWhen: (previous, current) {
        if (current is ReactPositionedUpdateState) {
          if (current.indexList.contains(widget.index)) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        model = _cubit.children[widget.index].model;

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
                    onDragStarted: onDragStartedCallback,
                    onDragUpdate: onDragUpdateCallback,
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
        return false;
      },
      listener: (context, state) {},
    );
  }

  // get

  double get crossAxisOverflow => reactGridViewModel.crossAxisSpacing >
          reactGridViewModel.clickableWidth
      ? 0
      : reactGridViewModel.clickableWidth - reactGridViewModel.crossAxisSpacing;

  double get height =>
      model.mainAxisCount * reactGridViewModel.mainAxisStride +
      mainAxisOverflow;

  double get heightWithoutMargin => height - margin.vertical;

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

  double get top =>
      model.mainAxisOffsetCount * reactGridViewModel.mainAxisStride -
      mainAxisOverflow / 2;

  double get width =>
      model.crossAxisCount * reactGridViewModel.crossAxisStride +
      crossAxisOverflow;

  double get widthWithoutMargin => width - margin.horizontal;

  // move

  void onDragStartedCallback() {
    offset = Offset.zero;
    startOffsetX = model.crossAxisOffsetCount;
    startOffsetY = model.mainAxisOffsetCount;
    previousOffsetX = 0;
    previousOffsetY = 0;
  }

  void onDragUpdateCallback(DragUpdateDetails details) {
    offset += details.delta;
    int offsetX = (offset.dx / reactGridViewModel.crossAxisStride).round();
    int offsetY = (offset.dy / reactGridViewModel.mainAxisStride).round();

    if (offsetX == previousOffsetX && offsetY == previousOffsetY) return;

    previousOffsetX = offsetX;
    previousOffsetY = offsetY;

    offsetX += startOffsetX;
    offsetY += startOffsetY;

    if (model.crossAxisOffsetCount == offsetX &&
        model.mainAxisOffsetCount == offsetY) return;

    if (offsetX < 0 ||
        offsetX + model.crossAxisCount > reactGridViewModel.crossAxisCount)
      return;

    if (offsetY < 0 ||
        offsetY + model.mainAxisCount > reactGridViewModel.mainAxisCount)
      return;

    _cubit.movedChild(
        widget.index,
        model.copyWith(
            crossAxisOffsetCount: offsetX, mainAxisOffsetCount: offsetY));
  }
}
