import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../react_grid_view.dart';

part 'resizable_overlay.dart';
part 'resize_gesture_detector.dart';

typedef ReactPositionedModelChangeEndCallback = void Function(
    int index, ReactPositionedModel model);

typedef ReactPositionedIndexChangeCallback = void Function(
    int previous, int current);

class ReactPositioned {
  ReactPositioned({
    Key key,
    this.child,
    int crossAxisCount = 1,
    int crossAxisOffsetCount = 0,
    bool horizontalResizable = true,
    int mainAxisCount = 1,
    int mainAxisOffsetCount = 0,
    int maxCrossAxisCount,
    int maxMainAxisCount,
    int minCrossAxisCount,
    int minMainAxisCount,
    bool movable = true,
    this.onModelChangeEnd,
    this.onIndexChange,
    bool verticalResizable = true,
  })  : this.key = key ?? UniqueKey(),
        this.model = ReactPositionedModel(
          crossAxisCount: crossAxisCount,
          crossAxisOffsetCount: crossAxisOffsetCount,
          horizontalResizable: horizontalResizable,
          mainAxisCount: mainAxisCount,
          mainAxisOffsetCount: mainAxisOffsetCount,
          maxCrossAxisCount: maxCrossAxisCount ?? crossAxisCount,
          maxMainAxisCount: maxMainAxisCount ?? mainAxisCount,
          minCrossAxisCount: minCrossAxisCount ?? crossAxisCount,
          minMainAxisCount: minMainAxisCount ?? mainAxisCount,
          movable: movable,
          verticalResizable: verticalResizable,
        );

  ReactPositioned.fromModel({
    Key key,
    this.child,
    this.model,
    this.onModelChangeEnd,
    this.onIndexChange,
  }) : this.key = key ?? UniqueKey();

  final Widget child;

  ReactGridViewCubit cubit;

  int _index;
  int get index => _index;
  set index(int index) {
    if (onIndexChange != null) onIndexChange(_index, index);
    _index = index;
  }

  final Key key;

  ReactPositionedModel model;

  final ReactPositionedModelChangeEndCallback onModelChangeEnd;

  final ReactPositionedIndexChangeCallback onIndexChange;

  _ReactPositioned toWidget() => _ReactPositioned(
        reactPositioned: this,
      );

  void removeSelf() {
    cubit.removeChild(index);
  }
}

class _ReactPositioned extends StatefulWidget {
  _ReactPositioned({this.reactPositioned}) : super(key: reactPositioned.key);

  final ReactPositioned reactPositioned;

  @override
  _ReactPositionedState createState() => _ReactPositionedState();
}

class _ReactPositionedState extends State<_ReactPositioned> {
  bool editable = true;

  ReactPositionedModel model;

  ReactGridViewModel reactGridViewModel;

  Offset offset;

  _ResizableOverlay overlay;

  int previousCrossAxisCount;
  int previousCrossAxisOffsetCount;
  int previousMainAxisCount;
  int previousMainAxisOffsetCount;

  double startHeight;
  double startLeft;
  ReactPositionedModel startModel;
  double startTop;
  double startWidth;

  @override
  Widget build(BuildContext context) {
    reactGridViewModel = cubit.model;
    return BlocConsumer<ReactGridViewCubit, ReactGridViewState>(
      cubit: cubit,
      buildWhen: (previous, current) {
        if (current is ReactPositionedUpdateState) {
          if (current.indexList.contains(index)) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        model = cubit.children[index].model;

        return Positioned(
          left: left,
          top: top,
          child: _build(),
        );
      },
      listenWhen: (previous, current) {
        return false;
      },
      listener: (context, state) {},
    );
  }

  Widget _build() {
    int mode = 0;
    if (editable) {
      mode = resizable ? 1 : 0;
      mode += model.movable ? 2 : 0;
    }

    switch (mode) {
      case 1:
        // resizable
        return GestureDetector(
          child: Container(
            child: child,
            height: heightWithoutMargin,
            margin: margin,
            width: widthWithoutMargin,
          ),
          onLongPressStart: (details) => _openResizeOverlay(),
        );
      case 2:
      // movable
      case 3:
        // resizable + movable
        return LongPressDraggable(
          child: Container(
            child: child,
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
                child: child,
                scale: 1.05,
              ),
              height: heightWithoutMargin,
              margin: margin,
              width: widthWithoutMargin,
            ),
          ),
          onDragEnd: onDragEndCallback,
          onDragStarted: onDragStartedCallback,
          onDragUpdate: onDragUpdateCallback,
        );
      default:
        // uneditable
        return Container(
          child: child,
          height: heightWithoutMargin,
          margin: margin,
          width: widthWithoutMargin,
        );
    }
  }

  // get

  Widget get child => widget.reactPositioned.child;

  double get crossAxisOverflow => reactGridViewModel.crossAxisSpacing >
          reactGridViewModel.clickableWidth
      ? 0
      : reactGridViewModel.clickableWidth - reactGridViewModel.crossAxisSpacing;

  ReactGridViewCubit get cubit => widget.reactPositioned.cubit;

  double get height =>
      model.mainAxisCount * reactGridViewModel.mainAxisStride +
      mainAxisOverflow;
  double get heightWithoutMargin => height - margin.vertical;

  int get index => widget.reactPositioned.index;

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

  double get maxHeight =>
      model.maxMainAxisCount * reactGridViewModel.mainAxisStride +
      mainAxisOverflow;
  double get maxWidth =>
      model.maxCrossAxisCount * reactGridViewModel.crossAxisStride +
      crossAxisOverflow;

  double get minHeight =>
      model.minMainAxisCount * reactGridViewModel.mainAxisStride +
      mainAxisOverflow;
  double get minWidth =>
      model.minCrossAxisCount * reactGridViewModel.crossAxisStride +
      crossAxisOverflow;

  bool get resizable => (model.horizontalResizable || model.verticalResizable);

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
    startModel = model.copyWith();

    previousCrossAxisOffsetCount = startModel.crossAxisOffsetCount;
    previousMainAxisOffsetCount = startModel.mainAxisOffsetCount;
  }

  void onDragUpdateCallback(DragUpdateDetails details) {
    offset += details.delta;
    int crossAxisOffsetCount =
        (offset.dx / reactGridViewModel.crossAxisStride).round() +
            startModel.crossAxisOffsetCount;
    int mainAxisOffsetCount =
        (offset.dy / reactGridViewModel.mainAxisStride).round() +
            startModel.mainAxisOffsetCount;

    if (crossAxisOffsetCount < 0 || mainAxisOffsetCount < 0) return;

    ReactPositionedModel nextModel = model.copyWith(
        crossAxisOffsetCount: crossAxisOffsetCount,
        mainAxisOffsetCount: mainAxisOffsetCount);

    if (reactGridViewModel.checkOverflow(nextModel)) return;

    if (previousCrossAxisOffsetCount != crossAxisOffsetCount ||
        previousMainAxisOffsetCount != mainAxisOffsetCount) {
      previousCrossAxisOffsetCount = crossAxisOffsetCount;
      previousMainAxisOffsetCount = mainAxisOffsetCount;
      cubit.childMoveUpdated(
          index,
          model.copyWith(
              crossAxisOffsetCount: crossAxisOffsetCount,
              mainAxisOffsetCount: mainAxisOffsetCount));
    }
  }

  // move end + resize

  void onDragEndCallback(DraggableDetails details) {
    cubit.childMoveEnd();

    if (resizable) _openResizeOverlay();
  }

  // resize

  void _openResizeOverlay() {
    if (overlay == null) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final Offset globalOffset = box.localToGlobal(Offset.zero);
      overlay = _ResizableOverlay(
        clickableWidth: reactGridViewModel.clickableWidth,
        horizontalResizable: model.horizontalResizable,
        height: height,
        width: width,
        margin: margin,
        left: globalOffset.dx,
        top: globalOffset.dy,
        onPanDown: resizeOnPanDownCallback,
        onPanDownClose: resizeOnPanDownCloseCallback,
        onPanEnd: resizeOnPanEndCallback,
        onPanUpdateBottom: resizeOnPanUpdateBottomCallback,
        onPanUpdateLeft: resizeOnPanUpdateLeftCallback,
        onPanUpdateRight: resizeOnPanUpdateRightCallback,
        onPanUpdateTop: resizeOnPanUpdateTopCallback,
        overlayState: Overlay.of(context, debugRequiredFor: widget),
        verticalResizable: model.verticalResizable,
      );
    }
  }

  void resizeOnPanDownCloseCallback(DragDownDetails details) {
    if (overlay != null) {
      cubit.childResizeEnd();

      overlay.close();
      overlay = null;
    }
  }

  void resizeOnPanDownCallback(DragDownDetails details) {
    offset = Offset.zero;
    startHeight = overlay.height;
    startLeft = overlay.left;
    startModel = model.copyWith();
    startTop = overlay.top;
    startWidth = overlay.width;

    previousCrossAxisCount = startModel.crossAxisCount;
    previousMainAxisCount = startModel.mainAxisCount;
  }

  void resizeOnPanEndCallback(DragEndDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset globalOffset = box.localToGlobal(Offset.zero);
    overlay.height = height;
    overlay.left = globalOffset.dx;
    overlay.top = globalOffset.dy;
    overlay.width = width;
    overlay.overlayEntry.markNeedsBuild();
  }

  void resizeOnPanUpdateBottomCallback(DragUpdateDetails details) {
    offset += details.delta;
    overlay.height = startHeight + offset.dy;

    int maxMainAxisCount =
        reactGridViewModel.mainAxisCount - startModel.mainAxisOffsetCount;
    if (maxMainAxisCount >= startModel.maxMainAxisCount)
      overlay.height = overlay.height.clamp(minHeight, maxHeight + 10);
    else {
      overlay.height = overlay.height.clamp(
          minHeight,
          maxMainAxisCount * reactGridViewModel.mainAxisStride +
              mainAxisOverflow +
              10);
    }

    overlay.overlayEntry.markNeedsBuild();

    int mainAxisCount =
        (overlay.height / reactGridViewModel.mainAxisStride).floor();

    if (previousMainAxisCount != mainAxisCount) {
      previousMainAxisCount = mainAxisCount;
      cubit.childResizeUpdate(
          index, startModel.copyWith(mainAxisCount: mainAxisCount));
    }
  }

  void resizeOnPanUpdateLeftCallback(DragUpdateDetails details) {
    offset += details.delta;
    overlay.width = startWidth - offset.dx;

    int maxCrossAxisCount =
        startModel.crossAxisOffsetCount + startModel.crossAxisCount;
    if (maxCrossAxisCount >= startModel.maxCrossAxisCount)
      overlay.width = overlay.width.clamp(minWidth, maxWidth + 10);
    else {
      overlay.width = overlay.width.clamp(
          minWidth,
          maxCrossAxisCount * reactGridViewModel.crossAxisStride +
              crossAxisOverflow +
              10);
    }

    overlay.left = startLeft + startWidth - overlay.width;

    overlay.overlayEntry.markNeedsBuild();

    int crossAxisCount =
        (overlay.width / reactGridViewModel.crossAxisStride).floor();
    int crossAxisOffsetCount = maxCrossAxisCount - crossAxisCount;

    if (previousCrossAxisCount != crossAxisCount) {
      previousCrossAxisCount = crossAxisCount;
      cubit.childResizeUpdate(
          index,
          startModel.copyWith(
              crossAxisCount: crossAxisCount,
              crossAxisOffsetCount: crossAxisOffsetCount));
    }
  }

  void resizeOnPanUpdateRightCallback(DragUpdateDetails details) {
    offset += details.delta;
    overlay.width = startWidth + offset.dx;

    int maxCrossAxisCount =
        reactGridViewModel.crossAxisCount - startModel.crossAxisOffsetCount;
    if (maxCrossAxisCount >= startModel.maxCrossAxisCount)
      overlay.width = overlay.width.clamp(minWidth, maxWidth + 10);
    else {
      overlay.width = overlay.width.clamp(
          minWidth,
          maxCrossAxisCount * reactGridViewModel.crossAxisStride +
              crossAxisOverflow +
              10);
    }

    overlay.overlayEntry.markNeedsBuild();

    int crossAxisCount =
        (overlay.width / reactGridViewModel.crossAxisStride).floor();

    if (previousCrossAxisCount != crossAxisCount) {
      previousCrossAxisCount = crossAxisCount;
      cubit.childResizeUpdate(
          index,
          startModel.copyWith(
            crossAxisCount: crossAxisCount,
          ));
    }
  }

  void resizeOnPanUpdateTopCallback(DragUpdateDetails details) {
    offset += details.delta;
    overlay.height = startHeight - offset.dy;

    int maxMainAxisCount =
        startModel.mainAxisOffsetCount + startModel.mainAxisCount;
    if (maxMainAxisCount >= startModel.maxMainAxisCount)
      overlay.height = overlay.height.clamp(minHeight, maxHeight + 10);
    else {
      overlay.height = overlay.height.clamp(
          minHeight,
          maxMainAxisCount * reactGridViewModel.mainAxisStride +
              mainAxisOverflow +
              10);
    }

    overlay.top = startTop + startHeight - overlay.height;

    overlay.overlayEntry.markNeedsBuild();

    int mainAxisCount =
        (overlay.height / reactGridViewModel.mainAxisStride).floor();
    int mainAxisOffsetCount = maxMainAxisCount - mainAxisCount;

    if (previousMainAxisCount != mainAxisCount) {
      previousMainAxisCount = mainAxisCount;
      cubit.childResizeUpdate(
          index,
          startModel.copyWith(
              mainAxisCount: mainAxisCount,
              mainAxisOffsetCount: mainAxisOffsetCount));
    }
  }
}
