import 'dart:math' as math;

List<List<List<T>>> getAllPossibleGroupings<T>(List<T> list) {
  if (list.isEmpty) {
    return [
      []
    ];
  }
  List<Selection<T>> subsets = getSubsetsWithComplements(list.skip(1).toList());
  return subsets
      .map(
        (subset) => getAllPossibleGroupings(subset.left).map(
          (e) => [
            [
              list[0],
              ...subset.selected
            ],
            ...e
          ],
        ),
      )
      .concatenate()
      .toList();
}

List<Selection<T>> getSubsetsWithComplements<T>(List<T> list) {
  final List<Selection<T>> result = [];
  for (var i = 0; i < math.pow(2, list.length); i++) {
    final Selection<T> selection = Selection<T>.empty();
    for (var q = 0; q < list.length; q++) {
      if ((i & (1 << q)) == 0) {
        selection.left.add(list[q]);
      } else {
        selection.selected.add(list[q]);
      }
    }
    result.add(selection);
  }
  return result;
}

class Selection<T> {
  final List<T> selected;
  final List<T> left;
  Selection(this.selected, this.left);
  Selection.empty()
      : selected = [],
        left = [];
}

extension CombinatoricsIterableIterable<T> on Iterable<Iterable<T>> {
  Iterable<T> concatenate() => fold(
        <T>[],
        (previousValue, element) => [
          ...previousValue,
          ...element
        ],
      );
}

extension CombinatoricsList<T> on List<T> {
  T maximizes<S extends num>(S Function(T) selector) {
    if (isEmpty) {
      throw ArgumentError('List is empty.');
    }
    S bestValue = selector(this[0]);
    T bestElement = this[0];
    for (T element in this) {
      S value = selector(element);
      if (value > bestValue) {
        bestValue = value;
        bestElement = element;
      }
    }
    return bestElement;
  }

  T minimizes<S extends num>(S Function(T) selector) => maximizes((element) => -selector(element));

  double sum(double Function(T) selector) => fold(0, (accumulated, element) => accumulated + selector(element));
}

extension CombinatoricsListList<T> on List<List<T>> {
  List<List<T>> oneFromEach() {
    if (isEmpty) {
      return [
        []
      ];
    }
    return this[0]
        .map(
          (elementFirstList) => skip(1).toList().oneFromEach().map(
                (elementsRest) => [
                  elementFirstList,
                  ...elementsRest
                ],
              ),
        )
        .concatenate()
        .toList();
  }
}

extension CombinatoricsNum<T extends num> on T {
  T get squared => (this * this) as T;
}
