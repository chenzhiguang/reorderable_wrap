import 'package:flutter/material.dart';
import './notifier.dart';

class ReorderableWrapProvider extends InheritedNotifier {
  final _State state = _State();
  final ReorderableWrapNotifier notifier;
  final Function(int oldIndex, int newIndex) onReorder;

  ReorderableWrapProvider({
    this.notifier,
    this.onReorder,
    Key key,
    Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  @override
  bool updateShouldNotify(InheritedNotifier oldWidget) {
    return true;
  }

  RenderBox get feedbackBox =>
      state.feedbackKey?.currentContext?.findRenderObject();

  void startDragging({ValueKey draggingKey, GlobalKey feedbackKey}) {
    if (state.inited != true) {
      Size size;
      List<Offset> offsets = [];
      state.elements.forEach((element) {
        RenderBox box = element.findRenderObject();
        offsets.add(box.localToGlobal(Offset.zero));
        if (size == null) {
          size = box.size;
        }
      });
      state.size = size;
      state.offsets = offsets;
      state.inited = true;
    }

    final int index = notifier.findIndex(draggingKey);
    state.newIndex = index;
    state.oldIndex = index;
    state.feedbackKey = feedbackKey;
    state.active = true;
  }

  void endDragging() {
    state.active = false;
    notifier.reset();
    if (onReorder != null) {
      onReorder(state.oldIndex, state.newIndex);
    }
  }

  addElement(BuildContext element) {
    state.elements.add(element);
  }

  void move(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      return;
    }

    notifier.move(oldIndex, newIndex);
    state.newIndex = newIndex;
    state.elements.clear();
  }

  static ReorderableWrapProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ReorderableWrapProvider>();
  }
}

class _State {
  final List<BuildContext> elements = [];
  List<Offset> offsets;
  Size size;
  bool active;
  bool inited;
  int newIndex;
  int oldIndex;
  GlobalKey feedbackKey;
}
