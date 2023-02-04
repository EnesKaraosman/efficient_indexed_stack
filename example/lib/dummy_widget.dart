import 'package:flutter/material.dart';

class DummyWidget extends StatefulWidget {
  const DummyWidget(this.index, {super.key});

  final int index;

  @override
  State<DummyWidget> createState() => _DummyWidgetState();
}

class _DummyWidgetState extends State<DummyWidget> {
  final _dummyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print('[_DummyWidgetState.initState: ${widget.index}]');
  }

  @override
  void dispose() {
    super.dispose();
    print('[_DummyWidgetState.dispose: ${widget.index}]');
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '_DummyWidgetState.Index: ${widget.index}',
      key: _dummyKey,
    );
  }
}
