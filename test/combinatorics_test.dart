import 'package:flutter_test/flutter_test.dart';
import 'package:rpn_calculator/combinatorics.dart';

void mockSetState(void Function() function) => function();

void main() {
  group('getSubsetsWithComplements', () {
    test('Empty list', () {
      expectPermutablySame(
        getSubsetsWithComplements([]),
        [
          Selection(<int>[], [])
        ],
      );
    });
    test('1 long list', () {
      expectPermutablySame(
        getSubsetsWithComplements([
          1
        ]),
        [
          Selection(<int>[], [
            1
          ]),
          Selection([
            1
          ], <int>[]),
        ],
      );
    });
    test('2 long list', () {
      expectPermutablySame(
        getSubsetsWithComplements([
          1,
          2
        ]),
        [
          Selection(<int>[], [
            1,
            2
          ]),
          Selection([
            1
          ], [
            2
          ]),
          Selection([
            2
          ], [
            1
          ]),
          Selection([
            1,
            2
          ], <int>[]),
        ],
      );
    });
    test('3 long list', () {
      expectPermutablySame(
        getSubsetsWithComplements([
          1,
          2,
          3
        ]),
        [
          Selection(<int>[], [
            1,
            2,
            3
          ]),
          Selection([
            1
          ], [
            2,
            3
          ]),
          Selection([
            2
          ], [
            1,
            3
          ]),
          Selection([
            1,
            2
          ], [
            3
          ]),
          Selection([
            3
          ], [
            1,
            2
          ]),
          Selection([
            1,
            3
          ], [
            2
          ]),
          Selection([
            2,
            3
          ], [
            1
          ]),
          Selection([
            1,
            2,
            3
          ], <int>[]),
        ],
      );
    });
  });
  group('getAllPossibleGroupings', () {
    test('Empty list', () {
      expectPermutablySame(getAllPossibleGroupings([]), [
        []
      ]);
    });
    test('1 long list', () {
      expectPermutablySame(
          getAllPossibleGroupings([
            1
          ]),
          [
            [
              [
                1
              ]
            ]
          ]);
    });
    test('2 long list', () {
      expectPermutablySame(
        getAllPossibleGroupings([
          1,
          2
        ]),
        [
          [
            [
              1
            ],
            [
              2
            ]
          ],
          [
            [
              1,
              2
            ]
          ]
        ],
      );
    });
    test('3 long list', () {
      expectPermutablySame(
        getAllPossibleGroupings([
          1,
          2,
          3
        ]),
        [
          [
            [
              1,
              2,
              3
            ]
          ],
          [
            [
              1,
              2
            ],
            [
              3
            ]
          ],
          [
            [
              1
            ],
            [
              2,
              3
            ]
          ],
          [
            [
              1,
              3
            ],
            [
              2
            ]
          ],
          [
            [
              1
            ],
            [
              2
            ],
            [
              3
            ]
          ]
        ],
      );
    });
  });
  group('oneFromEach', () {
    test('Empty list', () {
      expectPermutablySame(<List<int>>[].oneFromEach(), [
        []
      ]);
    });
    test('1 long list', () {
      expectPermutablySame(
        [
          [
            1
          ]
        ].oneFromEach(),
        [
          [
            1
          ]
        ],
      );
    });
    test('1 5 long list', () {
      expectPermutablySame(
        [
          [
            1
          ]
        ].oneFromEach(),
        [
          [
            1
          ]
        ],
      );
    });
    test('2 normal lists', () {
      expectPermutablySame(
        [
          [
            1,
            2
          ],
          [
            3,
            4,
            5
          ]
        ].oneFromEach(),
        [
          [
            1,
            3
          ],
          [
            1,
            4
          ],
          [
            1,
            5
          ],
          [
            2,
            3
          ],
          [
            2,
            4
          ],
          [
            2,
            5
          ],
        ],
      );
    });
    test('5 lists with 1 empty', () {
      expectPermutablySame(
        [
          [
            1,
            2
          ],
          [
            3,
            4,
            5
          ],
          [
            6,
            7
          ],
          [],
          [
            8,
            9
          ]
        ].oneFromEach(),
        [],
      );
    });
    test('4 lists with 2 of size 1', () {
      expectPermutablySame(
        [
          [
            1,
            2
          ],
          [
            3
          ],
          [
            4,
            5
          ],
          [
            6
          ]
        ].oneFromEach(),
        [
          [
            1,
            3,
            4,
            6
          ],
          [
            2,
            3,
            4,
            6
          ],
          [
            1,
            3,
            5,
            6
          ],
          [
            2,
            3,
            5,
            6
          ]
        ],
      );
    });
  });
}

void expectPermutablySame(dynamic actual, dynamic matcher) {
  String? result = isPermutablySame(actual, matcher);
  if (result != null) fail(result);
}

String? isPermutablySame(dynamic actual, dynamic matcher) {
  if (actual is List && matcher is List) {
    if (actual.length != matcher.length) {
      return "The length of the result was '${actual.length}' while the expected length was ${matcher.length}.";
    }
    List left = [
      ...actual
    ];
    for (dynamic elementMatcher in matcher) {
      bool elementFound = false;
      for (var elementActual in left) {
        if (isPermutablySame(elementActual, elementMatcher) == null) {
          elementFound = true;
          left.remove(elementActual);
          break;
        }
      }
      if (!elementFound) {
        return "'$elementMatcher' was in the result list fewer times than expected.";
      }
    }
    return left.isEmpty ? null : "'${left[0]}' was more times in the result list than expected.";
  } else if (actual is Selection && matcher is Selection) {
    return isPermutablySame(actual.selected, matcher.selected) ?? isPermutablySame(actual.left, matcher.left);
  } else {
    return actual == matcher ? null : "The actual value '$actual' was not the expected value '$matcher'.";
  }
}
