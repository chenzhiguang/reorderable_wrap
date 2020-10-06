import 'package:flutter/material.dart';

class ReorderableWrapNotifier<T extends Widget> extends ChangeNotifier {
  final List<T> children;
  List<T> _children = [];
  bool changed = false;

  ReorderableWrapNotifier({this.children}) {
    _children.clear();
    _children.addAll(children);
  }

  void move(int oldIndex, int newIndex) {
    if (changed == false) {
      changed = true;
    }

    try {
      children.insert(newIndex, children.removeAt(oldIndex));
      notifyListeners();
    } catch (e) {
      print('Error: ReorderableWrapNotifier.move');
    }
  }

  void reset() {
    if (changed == false) {
      return;
    }

    children.clear();
    children.addAll(_children);
    changed = false;
    notifyListeners();
  }

  int findIndex(ValueKey key) {
    int index = 0;

    for (final T element in _children) {
      if (element.key == key) {
        break;
      }
      index++;
    }

    return index;
  }
}
