import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:lazy_indexed_stack/src/index_calculation_strategy.dart';

import 'keep_alive_indices_calculator.dart';

/// It's an IndexedStack that only builds the widgets that are in the range of the
/// current index and the keepAliveDistance
class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.itemBuilder,
    this.keepAliveDistance = 5,
    this.indexCalculationStrategy = IndexCalculationStrategy.aroundCurrentIndex,
    this.alignment = AlignmentDirectional.topStart,
    this.sizing = StackFit.loose,
    this.textDirection,
  });

  /// How to align the non-positioned and partially-positioned children in the
  /// stack.
  ///
  /// The non-positioned children are placed relative to each other such that
  /// the points determined by [alignment] are co-located. For example, if the
  /// [alignment] is [Alignment.topLeft], then the top left corner of
  /// each non-positioned child will be located at the same global coordinate.
  ///
  /// Partially-positioned children, those that do not specify an alignment in a
  /// particular axis (e.g. that have neither `top` nor `bottom` set), use the
  /// alignment to determine how they should be positioned in that
  /// under-specified axis.
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// How to size the non-positioned children in the stack.
  ///
  /// The constraints passed into the [Stack] from its parent are either
  /// loosened ([StackFit.loose]) or tightened to their biggest size
  /// ([StackFit.expand]).
  final StackFit sizing;

  /// The text direction with which to resolve [alignment].
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  /// It's a enum that defines the strategy to calculate the indexes to keep alive.
  final IndexCalculationStrategy indexCalculationStrategy;

  /// The total number of children
  final int itemCount;

  /// The index of the child to show.
  final int currentIndex;

  /// It's a function that returns a widget.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// It's the number of children to keep alive around the current index.
  final int keepAliveDistance;

  static final Set<int> _keepAliveChildrenIndexes = {};

  @override
  LazyIndexedStackState createState() => LazyIndexedStackState();
}

class LazyIndexedStackState extends State<LazyIndexedStack> {
  final Map<int, Widget> _children = {};
  final _stackKey = GlobalKey();

  int get _currentIndex => widget.currentIndex;

  int get _maxIndex => widget.itemCount - 1;

  void _initializeWidgetsBasedOnKeepAliveRange({
    required int currentIndex,
    required int keepAliveCount,
  }) {
    final indices = KeepAliveIndicesCalculator(
      maxIndex: _maxIndex,
      currentIndex: _currentIndex,
      keepAliveCount: widget.keepAliveDistance,
      calculationStrategy: widget.indexCalculationStrategy,
    ).getIndices();
    for (var index in indices) {
      LazyIndexedStack._keepAliveChildrenIndexes.add(index);
      _children[index] = widget.itemBuilder(context, index);
    }
  }

  void _placeholderInitialization() {
    List.generate(
      widget.itemCount,
      (index) => const SizedBox.shrink(),
    )
        .asMap()
        .entries
        .forEach((element) => _children.addAll({element.key: element.value}));
  }

  void _buildChildrenBasedOnDifference(Set<int> toBeBuiltIndexes) {
    for (final index in toBeBuiltIndexes) {
      _children[index] = widget.itemBuilder(context, index);
    }
  }

  void _disposeChildrenBasedOnChange(Set<int> toBeDisposedIndexes) {
    for (final index in toBeDisposedIndexes) {
      _children[index] = const SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    _placeholderInitialization();
    _initializeWidgetsBasedOnKeepAliveRange(
      currentIndex: _currentIndex,
      keepAliveCount: widget.keepAliveDistance,
    );
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      final keepAliveIndexes = KeepAliveIndicesCalculator(
        maxIndex: _maxIndex,
        currentIndex: _currentIndex,
        keepAliveCount: widget.keepAliveDistance,
        calculationStrategy: widget.indexCalculationStrategy,
      ).getIndices();

      final toBeDisposedIndexes = LazyIndexedStack._keepAliveChildrenIndexes
          .difference(keepAliveIndexes);

      final toBeBuiltIndexes = keepAliveIndexes
          .difference(LazyIndexedStack._keepAliveChildrenIndexes);

      _buildChildrenBasedOnDifference(toBeBuiltIndexes);
      _disposeChildrenBasedOnChange(toBeDisposedIndexes);
      LazyIndexedStack._keepAliveChildrenIndexes.clear();
      LazyIndexedStack._keepAliveChildrenIndexes.addAll(keepAliveIndexes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      key: _stackKey,
      index: widget.currentIndex,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: _children.values.toList(),
    );
  }
}
