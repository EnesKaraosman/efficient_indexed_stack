import 'package:flutter_test/flutter_test.dart';
import 'package:efficient_indexed_stack/src/index_calculation_strategy.dart';
import 'package:efficient_indexed_stack/src/keep_alive_indices_calculator.dart';

void main() {
  group('KeepAliveIndicesCalculator ', () {
    test('getIndicesAround test', () {
      final indexes = const KeepAliveIndicesCalculator(
        maxIndex: 4, // 0, (1), [2], (3), 4
        currentIndex: 2,
        keepAliveCount: 1,
        calculationStrategy: IndexCalculationStrategy.aroundCurrentIndex,
      ).getIndices();
      expect(indexes, {1, 2, 3});

      final indexes2 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // [0], (1), (2), (3), (4)
        currentIndex: 0,
        keepAliveCount: 2,
        calculationStrategy: IndexCalculationStrategy.aroundCurrentIndex,
      ).getIndices();
      expect(indexes2, {0, 1, 2, 3, 4});

      final indexes3 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // (0), (1), (2), (3), [4]
        currentIndex: 4,
        keepAliveCount: 2,
        calculationStrategy: IndexCalculationStrategy.aroundCurrentIndex,
      ).getIndices();
      expect(indexes3, {0, 1, 2, 3, 4});

      final indexes4 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // (0), (1), [2], (3), (4)
        currentIndex: 2,
        keepAliveCount: 10,
        calculationStrategy: IndexCalculationStrategy.aroundCurrentIndex,
      ).getIndices();
      expect(indexes4, {0, 1, 2, 3, 4});
    });

    test('getIndicesStart test', () {
      final indexes = const KeepAliveIndicesCalculator(
        maxIndex: 4, // 0, (1), [2], 3, 4
        currentIndex: 2,
        keepAliveCount: 1,
        calculationStrategy: IndexCalculationStrategy.beforeCurrentIndex,
      ).getIndices();
      expect(indexes, {1, 2});

      final indexes2 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // (0), (1), [2], 3, 4
        currentIndex: 2,
        keepAliveCount: 2,
        calculationStrategy: IndexCalculationStrategy.beforeCurrentIndex,
      ).getIndices();
      expect(indexes2, {0, 1, 2});

      final indexes3 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // [0], 1, 2, (3), (4)
        currentIndex: 0,
        keepAliveCount: 2,
        calculationStrategy: IndexCalculationStrategy.beforeCurrentIndex,
      ).getIndices();
      expect(indexes3, {0, 3, 4});

      final indexes4 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // [0], (1), (2), (3), (4)
        currentIndex: 0,
        keepAliveCount: 20,
        calculationStrategy: IndexCalculationStrategy.beforeCurrentIndex,
      ).getIndices();
      expect(indexes4, {0, 1, 2, 3, 4});
    });

    test('_getIndicesEnd test', () {
      final indexes = const KeepAliveIndicesCalculator(
        maxIndex: 4, // 0, 1, [2], (3), 4
        currentIndex: 2,
        keepAliveCount: 1,
        calculationStrategy: IndexCalculationStrategy.afterCurrentIndex,
      ).getIndices();
      expect(indexes, {2, 3});

      final indexes2 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // (0), (1), 2, 3, [4]
        currentIndex: 4,
        keepAliveCount: 2,
        calculationStrategy: IndexCalculationStrategy.afterCurrentIndex,
      ).getIndices();
      expect(indexes2, {0, 1, 4});

      final indexes3 = const KeepAliveIndicesCalculator(
        maxIndex: 4, // (0), (1), (2), (3), [4]
        currentIndex: 4,
        keepAliveCount: 20,
        calculationStrategy: IndexCalculationStrategy.afterCurrentIndex,
      ).getIndices();
      expect(indexes3, {0, 1, 2, 3, 4});
    });
  });
}
