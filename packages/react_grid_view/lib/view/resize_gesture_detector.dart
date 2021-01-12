part of 'react_positioned.dart';

typedef _ResizeDragCallback = void Function(PointerEvent event);

class _ResizePanGestureRecognizer extends OneSequenceGestureRecognizer {
  _ResizePanGestureRecognizer({
    @required this.onPanDown,
    @required this.onPanUpdate,
    @required this.onPanEnd,
  });

  final _ResizeDragCallback onPanDown;
  final _ResizeDragCallback onPanUpdate;
  final _ResizeDragCallback onPanEnd;

  @override
  void addPointer(PointerEvent event) {
    onPanDown(event);
    startTrackingPointer(event.pointer);
    resolve(GestureDisposition.accepted);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      onPanUpdate(event);
    }
    if (event is PointerUpEvent) {
      onPanEnd(event);
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}

class _ResizeGestureDetector extends StatelessWidget {
  _ResizeGestureDetector(
      {Key key, this.child, this.onPanDown, this.onPanEnd, this.onPanUpdate})
      : super(key: key);

  final GestureDragDownCallback onPanDown;
  final GestureDragEndCallback onPanEnd;
  final GestureDragUpdateCallback onPanUpdate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      child: child,
      gestures: <Type, GestureRecognizerFactory>{
        _ResizePanGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_ResizePanGestureRecognizer>(
          () => _ResizePanGestureRecognizer(
            onPanDown: (event) {
              if (onPanDown != null) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                onPanDown(DragDownDetails(
                    localPosition: event.localPosition,
                    globalPosition:
                        renderBox.localToGlobal(event.localPosition)));
              }
            },
            onPanUpdate: (event) {
              if (onPanUpdate != null) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                onPanUpdate(DragUpdateDetails(
                  sourceTimeStamp: event.timeStamp,
                  delta: event.delta,
                  globalPosition: renderBox.localToGlobal(event.localPosition),
                  localPosition: event.localPosition,
                ));
              }
            },
            onPanEnd: (event) {
              if (onPanEnd != null) onPanEnd(DragEndDetails());
            },
          ),
          (_ResizePanGestureRecognizer instance) {},
        ),
      },
    );
  }
}
