import 'package:flutter/material.dart';
import './notifier.dart';

class ReorderableWrapProvider
    extends InheritedNotifier<ReorderableWrapNotifier> {
  ReorderableWrapProvider({
    this.onReorder,
    Key key,
    Widget child,
    ReorderableWrapNotifier notifier,
  }) : super(key: key, notifier: notifier, child: child);

  final _State state = _State();
  final Function(int oldIndex, int newIndex) onReorder;

  @override
  bool updateShouldNotify(InheritedNotifier oldWidget) {
    return true;
  }

  RenderBox get feedbackBox =>
      state.feedbackKey?.currentContext?.findRenderObject();

  void startDragging({ValueKey draggingKey, GlobalKey feedbackKey}) {
    if (state.inited != true) {
      Size size;
      final offsets = <Offset>[];
      for (final element in state.elements) {
        final RenderBox box = element.findRenderObject();
        offsets.add(box.localToGlobal(Offset.zero));
        size ??= box.size;
      }
      state
        ..size = size
        ..offsets = offsets
        ..inited = true;
    }

    final index = notifier.findIndex(draggingKey);
    state
      ..newIndex = index
      ..oldIndex = index
      ..feedbackKey = feedbackKey
      ..active = true;
  }

  void endDragging() {
    state.active = false;
    notifier.reset();
    if (onReorder != null) {
      onReorder(state.oldIndex, state.newIndex);
    }
  }

  void addElement(BuildContext element) {
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
