import 'dart:collection';

import 'package:efficient_indexed_stack/src/index_calculation_strategy.dart';

class KeepAliveIndicesCalculator {
  const KeepAliveIndicesCalculator({
    required this.maxIndex,
    required this.currentIndex,
    required this.keepAliveCount,
    required this.calculationStrategy,
  });

  final int maxIndex;
  final int currentIndex;
  final int keepAliveCount;
  final IndexCalculationStrategy calculationStrategy;

  /// It returns a list of indices of items that are within a certain distance from
  /// the selected item
  ///
  /// Args:
  ///   listLength (int): The length of the list of items.
  ///   selectedIndex (int): The index of the selected item.
  ///   distance (int): The number of items to show on either side of the selected
  /// item.
  ///   strategy (CalculateIndicesStrategy): This is the strategy to use to
  /// calculate the indices.
  ///
  /// Returns:
  ///   A list of integers.
  Set<int> _getIndices(
    int listLength,
    int selectedIndex,
    int distance,
    IndexCalculationStrategy strategy,
  ) {
    Set<int> indices = {};
    int size = listLength;
    int clampedDistance = distance.clamp(0, listLength - 1);
    switch (strategy) {
      case IndexCalculationStrategy.aroundCurrentIndex:
        for (int i = 1; i <= clampedDistance; i++) {
          int leftIndex = selectedIndex - i >= 0
              ? selectedIndex - i
              : size - i + selectedIndex;
          int rightIndex = (selectedIndex + i) % size;
          indices.add(leftIndex);
          indices.add(rightIndex);
        }
        break;
      case IndexCalculationStrategy.afterCurrentIndex:
        for (int i = clampedDistance; i >= 1 && i <= size; i--) {
          int index = (selectedIndex + i) % size;
          indices.add(index);
        }
        break;
      case IndexCalculationStrategy.beforeCurrentIndex:
        for (int i = 1; i <= clampedDistance && i <= size; i++) {
          int index = selectedIndex - i >= 0
              ? selectedIndex - i
              : size - (i - selectedIndex);
          indices.add(index);
        }
        break;
    }
    return indices;
  }

  /// It returns a set of indices that should be kept alive
  ///
  /// Returns:
  ///   A set of integers.
  Set<int> getIndices() {
    final indices = _getIndices(
      maxIndex + 1,
      currentIndex,
      keepAliveCount,
      calculationStrategy,
    );

    return SplayTreeSet.from(indices)..add(currentIndex);
  }
}
