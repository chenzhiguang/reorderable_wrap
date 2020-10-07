import 'package:flutter/material.dart';
import './provider.dart';

class ReorderableWrapItem extends StatelessWidget {
  final Widget child;
  final ValueKey key;
  ReorderableWrapItem({
    @required this.child,
    @required this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey();
    final provider = ReorderableWrapProvider.of(context);
    provider.addElement(context);

    return LongPressDraggable(
      child: child,
      childWhenDragging: Opacity(
        child: child,
        opacity: 0,
      ),
      feedback: Container(
        key: _key,
        child: Opacity(
          opacity: 0.7,
          child: child,
        ),
      ),
      onDragStarted: () {
        provider.startDragging(
          feedbackKey: _key,
          draggingKey: key,
        );
      },
      onDragEnd: (details) {
        provider.endDragging();
      },
    );
  }
}
