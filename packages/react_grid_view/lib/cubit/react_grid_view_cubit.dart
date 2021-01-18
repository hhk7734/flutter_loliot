import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../react_grid_view.dart';

part 'react_grid_view_state.dart';

typedef ReactGridViewChildrenMoveCallback = void Function(List<int> indexList);

class ReactGridViewCubit extends Cubit<ReactGridViewState> {
  ReactGridViewCubit({
    List<ReactPositioned> children,
    ReactGridViewModel model,
    ReactGridViewChildrenMoveCallback onChildrenMove,
  })  : _model = model,
        _onChildrenMove = onChildrenMove,
        super(ReactGridViewInitial()) {
    if (children != null) children.forEach((e) => _addChild(e));
  }

  final Map<int, ReactPositioned> _children = <int, ReactPositioned>{};
  Map<int, ReactPositioned> get children => _children;

  ReactGridViewModel _model;
  ReactGridViewModel get model => _model;

  List<int> _movedIndexList = [];

  ReactGridViewChildrenMoveCallback _onChildrenMove;

  final List<int> _sequentialIndexList = <int>[];

  set width(double width) {
    _model = _model.copyWith(width: width);
  }

  bool _addChild(ReactPositioned child) {
    int index = _children.isEmpty ? 0 : _children.keys.last + 1;
    child.index = index;
    child.cubit = this;

    switch (_model.alignment) {
      case ReactGridViewAlignment.none:
        break;

      case ReactGridViewAlignment.sequential:
        child.model = child.model.copyWith(
          crossAxisCount: 1,
          crossAxisOffsetCount: (index) % _model.crossAxisCount,
          horizontalResizable: false,
          mainAxisCount: 1,
          mainAxisOffsetCount: (index) ~/ _model.crossAxisCount,
          maxCrossAxisCount: 1,
          maxMainAxisCount: 1,
          minCrossAxisCount: 1,
          minMainAxisCount: 1,
          movable: true,
          verticalResizable: false,
        );
        break;
    }

    if (_checkOverlap(-1, child.model)) return false;
    if (_model.checkOverflow(child.model)) return false;

    _children.putIfAbsent(index, () => child);
    _sequentialIndexList.add(index);
    return true;
  }

  bool addChild(ReactPositioned child) {
    switch (_model.alignment) {
      case ReactGridViewAlignment.none:
        int maxCrossAxisOffsetCount =
            _model.crossAxisCount - child.model.crossAxisCount;
        int maxMainAxisOffsetCount =
            _model.mainAxisCount - child.model.mainAxisCount;
        if (maxCrossAxisOffsetCount < 0 || maxMainAxisOffsetCount < 0)
          return false;

        for (int i = 0; i <= maxMainAxisOffsetCount; i++) {
          for (int j = 0; j <= maxCrossAxisOffsetCount; j++) {
            child.model = child.model
                .copyWith(crossAxisOffsetCount: j, mainAxisOffsetCount: i);
            if (_addChild(child)) {
              emit(ReactGridViewUpdateState(
                  _children.entries.map((e) => e.value.toWidget()).toList(),
                  _model));
              return true;
            }
          }
        }
        break;

      case ReactGridViewAlignment.sequential:
        if (_addChild(child)) {
          emit(ReactGridViewUpdateState(
              _children.entries.map((e) => e.value.toWidget()).toList(),
              _model));
          return true;
        }
        break;
    }
    return false;
  }

  bool _checkOverlap(int excludedIndex, ReactPositionedModel model) {
    return _children.entries.any((e) {
      if (e.key == excludedIndex) return false;
      return e.value.model.checkOverlap(model);
    });
  }

  void childMoveEnded() {
    if (_movedIndexList.length > 0) {
      if (_onChildrenMove != null) _onChildrenMove(_movedIndexList);
    }
  }

  void childMoveUpdated(int childIndex, ReactPositionedModel model) {
    _movedIndexList.clear();

    switch (_model.alignment) {
      case ReactGridViewAlignment.none:
        if (_checkOverlap(childIndex, model)) return;
        _children[childIndex].model = model;
        _movedIndexList.add(childIndex);
        break;

      case ReactGridViewAlignment.sequential:
        int startIndex = -1;
        int targetIndex;

        _children.entries.any(
          (e) {
            if (e.key == childIndex) return false;
            if (e.value.model.checkOverlap(model)) {
              // movedIndex
              startIndex = _sequentialIndexList.indexOf(childIndex);
              _sequentialIndexList.removeAt(startIndex);
              // targetIndex
              targetIndex = _sequentialIndexList.indexOf(e.key);
              if (targetIndex < startIndex) {
                _sequentialIndexList.insert(targetIndex, childIndex);
                startIndex = targetIndex;
              } else {
                targetIndex++;
                if (targetIndex > _sequentialIndexList.length)
                  targetIndex = _sequentialIndexList.length;
                _sequentialIndexList.insert(targetIndex, childIndex);
              }
              return true;
            }
            return false;
          },
        );

        if (startIndex == -1) {
          startIndex = _sequentialIndexList.indexOf(childIndex);
          if (startIndex == _sequentialIndexList.length - 1) return;
          _sequentialIndexList.removeAt(startIndex);
          _sequentialIndexList.add(childIndex);
        }

        _movedIndexList = _sequentialIndexList.sublist(startIndex);

        for (int i = 0; i < _movedIndexList.length; i++) {
          _children[_movedIndexList[i]].model = _children[_movedIndexList[i]]
              .model
              .copyWith(
                  crossAxisOffsetCount:
                      (startIndex + i) % _model.crossAxisCount,
                  mainAxisOffsetCount:
                      (startIndex + i) ~/ _model.crossAxisCount);
        }
        break;
    }

    if (_movedIndexList.length > 0) {
      emit(ReactPositionedUpdateState(_movedIndexList));
    }
  }

  void closeResizableOverlay() {
    emit(ReactPositionedCloseOvelayState());
  }

  void initView() {
    emit(ReactGridViewUpdateState(
        _children.entries.map((e) => e.value.toWidget()).toList(), _model));
  }

  void removeChild(int childIndex) {
    if (_children.keys.contains(childIndex)) {
      switch (_model.alignment) {
        case ReactGridViewAlignment.none:
          _children.remove(childIndex);
          _sequentialIndexList.remove(childIndex);
          emit(ReactGridViewUpdateState(
              _children.entries.map((e) => e.value.toWidget()).toList(),
              _model));
          break;
        case ReactGridViewAlignment.sequential:
          int startIndex = _sequentialIndexList.indexOf(childIndex);

          _children.remove(childIndex);
          _sequentialIndexList.remove(childIndex);

          List<int> indexList = _sequentialIndexList.sublist(startIndex);

          for (int i = 0; i < indexList.length; i++) {
            _children[indexList[i]].model = _children[indexList[i]]
                .model
                .copyWith(
                    crossAxisOffsetCount:
                        (startIndex + i) % _model.crossAxisCount,
                    mainAxisOffsetCount:
                        (startIndex + i) ~/ _model.crossAxisCount);
          }

          emit(ReactGridViewUpdateState(
              _children.entries.map((e) => e.value.toWidget()).toList(),
              _model));
          break;
      }
    }
  }

  void resizedChild(int index, ReactPositionedModel model) {
    List<int> indexList = [];

    switch (_model.alignment) {
      case ReactGridViewAlignment.none:
        if (_checkOverlap(index, model)) return;
        _children[index].model = model;
        indexList.add(index);
        break;

      case ReactGridViewAlignment.sequential:
        break;
    }

    if (indexList.length > 0) emit(ReactPositionedUpdateState(indexList));
  }
}
