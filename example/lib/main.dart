import 'package:example/my_cool_widget.dart';
import 'package:flutter/material.dart';
import 'package:lazy_indexed_stack/lazy_indexed_stack.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int activeIndex = 0;
  final itemCount = 30;

  int get maxIndex => itemCount - 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Active index : $activeIndex'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_left_rounded),
              onPressed: () => setState(() {
                activeIndex = (activeIndex - 1).clamp(0, maxIndex);
              }),
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.arrow_right_rounded),
              onPressed: () => setState(() {
                activeIndex = (activeIndex + 1).clamp(0, maxIndex);
              }),
            ),
          ],
        ),
        body: LazyIndexedStack(
          index: activeIndex,
          itemCount: itemCount,
          keepAliveDistance: 3,
          itemBuilder: (_, index) => MyCoolWidget(
            index,
            key: GlobalKey(),
          ),
        ),
      ),
    );
  }
}
