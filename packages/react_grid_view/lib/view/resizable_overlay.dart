part of 'react_positioned.dart';

class _ResizableOverlay {
  _ResizableOverlay({
    this.clickableWidth,
    this.height,
    @required this.horizontalResizable,
    this.left,
    this.margin,
    this.onPanDown,
    this.onPanDownCenter,
    this.onPanEnd,
    this.onPanUpdateBottom,
    this.onPanUpdateLeft,
    this.onPanUpdateRight,
    this.onPanUpdateTop,
    @required this.overlayState,
    this.top,
    @required this.verticalResizable,
    this.width,
  }) : assert(horizontalResizable || verticalResizable) {
    overlayEntry = OverlayEntry(builder: build);
    overlayState.insert(overlayEntry);
  }

  final double clickableWidth;
  double height;
  final bool horizontalResizable;
  double left;
  final EdgeInsets margin;
  final GestureDragDownCallback onPanDown;
  final GestureDragDownCallback onPanDownCenter;
  final GestureDragEndCallback onPanEnd;
  final GestureDragUpdateCallback onPanUpdateBottom;
  final GestureDragUpdateCallback onPanUpdateLeft;
  final GestureDragUpdateCallback onPanUpdateRight;
  final GestureDragUpdateCallback onPanUpdateTop;
  OverlayEntry overlayEntry;
  final OverlayState overlayState;
  double top;
  final bool verticalResizable;
  double width;

  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        child: Stack(
          children: [
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  color: Colors.transparent,
                ),
                margin: margin,
              ),
              onPanDown: onPanDownCenter,
            ),
            if (horizontalResizable)
              _ResizePoint(
                height: clickableWidth * 2,
                width: clickableWidth,
                left: margin.left - clickableWidth / 2,
                top: height / 2 - clickableWidth,
                onPanDown: onPanDown,
                onPanEnd: onPanEnd,
                onPanUpdate: onPanUpdateLeft,
              ),
            if (horizontalResizable)
              _ResizePoint(
                height: clickableWidth * 2,
                width: clickableWidth,
                left: width - margin.right - clickableWidth / 2,
                top: height / 2 - clickableWidth,
                onPanDown: onPanDown,
                onPanEnd: onPanEnd,
                onPanUpdate: onPanUpdateRight,
              ),
            if (verticalResizable)
              _ResizePoint(
                height: clickableWidth,
                width: clickableWidth * 2,
                left: width / 2 - clickableWidth,
                top: margin.top - clickableWidth / 2,
                onPanDown: onPanDown,
                onPanEnd: onPanEnd,
                onPanUpdate: onPanUpdateTop,
              ),
            if (verticalResizable)
              _ResizePoint(
                height: clickableWidth,
                width: clickableWidth * 2,
                left: width / 2 - clickableWidth,
                top: height - margin.bottom - clickableWidth / 2,
                onPanDown: onPanDown,
                onPanEnd: onPanEnd,
                onPanUpdate: onPanUpdateBottom,
              )
          ],
        ),
        height: height,
        width: width,
      ),
      left: left,
      top: top,
    );
  }

  void close() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}

class _ResizePoint extends StatelessWidget {
  _ResizePoint({
    this.height,
    this.left,
    this.onPanDown,
    this.onPanEnd,
    this.onPanUpdate,
    this.top,
    this.width,
  });

  final double height;
  final double left;
  final GestureDragDownCallback onPanDown;
  final GestureDragEndCallback onPanEnd;
  final GestureDragUpdateCallback onPanUpdate;
  final double top;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: _ResizeGestureDetector(
        child: Stack(
          children: [
            Positioned(
              child: Container(
                color: Colors.transparent,
                height: height,
                width: width,
              ),
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                height: 10,
                width: 10,
              ),
              left: width / 2 - 5,
              top: height / 2 - 5,
            )
          ],
        ),
        onPanDown: onPanDown,
        onPanEnd: onPanEnd,
        onPanUpdate: onPanUpdate,
      ),
      left: left,
      top: top,
    );
  }
}
