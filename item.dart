import 'package:flutter/material.dart';
import 'provider.dart';

// NOTE: all the items must be the same size
class ReorderableWrapItem extends StatelessWidget {
  const ReorderableWrapItem({
    @required this.child,
    @required Key key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey();
    final provider = ReorderableWrapProvider.of(context)..addElement(context);

    return LongPressDraggable(
      childWhenDragging: Opacity(
        opacity: 0,
        child: child,
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
      child: child,
    );
  }
}
