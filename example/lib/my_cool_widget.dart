import 'package:flutter/material.dart';

class MyCoolWidget extends StatefulWidget {
  const MyCoolWidget(this.index, {super.key});

  final int index;

  @override
  State<MyCoolWidget> createState() => _MyCoolWidgetState();
}

class _MyCoolWidgetState extends State<MyCoolWidget> {
  final _dummyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    debugPrint('[_MyCoolWidgetState.initState: ${widget.index}]');
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('[_MyCoolWidgetState.dispose: ${widget.index}]');
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '_MyCoolWidgetState.Index: ${widget.index}',
      key: _dummyKey,
    );
  }
}
