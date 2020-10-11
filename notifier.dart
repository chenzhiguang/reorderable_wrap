import 'package:flutter/material.dart';

class ReorderableWrapNotifier<T extends Widget> extends ChangeNotifier {
  ReorderableWrapNotifier({this.children}) {
    _children
      ..clear()
      ..addAll(children);
  }

  final List<T> children;
  final List<T> _children = [];
  bool changed = false;

  void move(int oldIndex, int newIndex) {
    if (changed == false) {
      changed = true;
    }

    try {
      children.insert(newIndex, children.removeAt(oldIndex));
      notifyListeners();
    } on Exception catch (e) {
      print('Error: ReorderableWrapNotifier.move\n${e.toString()}');
    }
  }

  void reset() {
    if (changed == false) {
      return;
    }

    children
      ..clear()
      ..addAll(_children);
    changed = false;
    notifyListeners();
  }

  int findIndex(ValueKey key) {
    var index = 0;

    for (final element in _children) {
      if (element.key == key) {
        break;
      }
      index++;
    }

    return index;
  }
}
