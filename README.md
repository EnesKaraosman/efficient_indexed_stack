# efficient_indexed_stack
 
Flutter's `IndexedStack` widget initializes the given `children` immediately.

This package handle initialization process so that children gets built lazily.

Minimal usage;

```dart
EfficientIndexedStack(
  index: index,
  itemCount: itemCount,
  itemBuilder: (_, index) => MyCoolWidget(
    index,
    key: GlobalKey(), // << IMPORTANT
  ),
),
```

### How many children initialized?

You can set `keepAliveDistance` parameter to decide how many indices must be alive.

```dart
EfficientIndexedStack(
  keepAliveDistance: 4,
  index: activeIndex,
  itemCount: itemCount,
  itemBuilder: (_, index) => MyCoolWidget(
    index,
    key: GlobalKey(), // << IMPORTANT
  ),
),
```

### Which indices are alive?

You can set `indexCalculationStrategy` parameter to decide which indices should be alive.

- `IndexCalculationStrategy.aroundCurrentIndex`

aroundCurrentIndex option initializes the current index and the indices before and after that based on `keepAliveDistance`

```dart
EfficientIndexedStack(
  indexCalculationStrategy: IndexCalculationStrategy.aroundCurrentIndex,
  keepAliveDistance: 3,
  index: 4,
  itemCount: 10,
  itemBuilder: (_, index) => MyCoolWidget(
    index,
    key: GlobalKey(), // << IMPORTANT
  ),
),

// 0, (1), (2), (3), [4], (5), (6), (7), 8, 9
```

- `IndexCalculationStrategy.beforeCurrentIndex`

```dart
EfficientIndexedStack(
  indexCalculationStrategy: IndexCalculationStrategy.beforeCurrentIndex,
  keepAliveDistance: 3,
  index: 4,
  itemCount: 10,
  itemBuilder: (_, index) => MyCoolWidget(
    index,
    key: GlobalKey(), // << IMPORTANT
  ),
),

// 0, (1), (2), (3), [4], 5, 7, 8, 9
```

- `IndexCalculationStrategy.afterCurrentIndex`

```dart
EfficientIndexedStack(
  indexCalculationStrategy: IndexCalculationStrategy.afterCurrentIndex,
  keepAliveDistance: 3,
  index: 4,
  itemCount: 10,
  itemBuilder: (_, index) => MyCoolWidget(
    index,
    key: GlobalKey(), // << IMPORTANT
  ),
),

// 0, 1, 2, 3, [4], (5), (7), (8), 9
```

Once you update the current index. Only the new indices are initialized and the others gets disposed.