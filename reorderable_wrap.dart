import 'package:flutter/material.dart';
import './notifier.dart';
import './provider.dart';
import './item.dart';
export './item.dart';

class ReorderableWrap extends StatelessWidget {
  final List<ReorderableWrapItem> children;
  final Function(int oldIndex, int newIndex) onReorder;
  ReorderableWrap({
    @required this.children,
    @required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableWrapProvider(
      onReorder: onReorder,
      notifier: ReorderableWrapNotifier<ReorderableWrapItem>(
        children: children,
      ),
      child: Builder(
        builder: (_context) {
          final provider = ReorderableWrapProvider.of(_context);
          return Listener(
            onPointerMove: (e) {
              final box = provider.feedbackBox;
              if (false == provider.state.active || null == box) {
                return;
              }
              final Offset offset = box.localToGlobal(Offset.zero);
              int newIndex = _findIndex(
                  offset, provider.state.offsets, provider.state.size);
              provider.move(provider.state.newIndex, newIndex);
            },
            child: Wrap(
              children: provider.notifier.children,
            ),
          );
        },
      ),
    );
  }
}

int _findIndex(Offset offset, List<Offset> offsets, Size size) {
  final Offset firstOffset = offsets[0];
  int index = 0;
  try {
    offsets.asMap().forEach((i, item) {
      final double dx = offset.dx + size.width / 2;
      final double dy = offset.dy + size.height / 2;
      if ((dx > item.dx && dy > item.dy) ||
          (dx > item.dx && dy < firstOffset.dy && firstOffset.dy == item.dy) ||
          (dy > item.dy && dx < firstOffset.dx && firstOffset.dx == item.dx)) {
        index = i;
      }
    });
    return index;
  } catch (e) {
    print('Error: _findIndex@ReorderableWrap');
    return 0;
  }
}
