
## Source files

+ reorderable_wrap.dart: `ReorderableWrap`, main widget
+ item.dart: `ReorderableWrapItem`, child widget of `ReorderableWrap`
+ notifier.dart: `ReorderableWrapNotifier`, the state of  `ReorderableWrapItem` items
+ provider.dart: `ReorderableWrapProvider` , 


## Example

```dart
import 'package:flutter/material.dart';
import 'package:./reorderable_wrap.dart';

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  List<IconData> elements = [
    Icons.traffic,
    Icons.nature,
    Icons.eco,
    Icons.train,
    Icons.motorcycle,
    Icons.flight,
    Icons.ac_unit,
    Icons.dangerous,
  ];

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: SingleChildScrollView(
        child: ReorderableWrap(
          onReorder: (oldIndex, newIndex) {
            setState(() {
              elements.insert(newIndex, elements.removeAt(oldIndex));
            });
          },
          children: elements.map((icon) {
            return ReorderableWrapItem(
              key: ValueKey(icon),
              child: SizedBox(
                width: size,
                height: size,
                child: Icon(
                  icon,
                  size: size / 1.3,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
```