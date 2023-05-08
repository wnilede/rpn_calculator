import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_functions.dart';
import 'package:rpn_calculator/layout_optimization/minimize_square_optimizer.dart' as mso;
import 'package:rpn_calculator/layout_optimization/inverted.dart' as inv;

void main() {
  const sizesToTry = [
    Size(100, 1000),
    Size(20, 20),
    Size(500, 20),
    Size(374, 374),
    Size(200000, 100000),
    Size(9872, 2385),
    Size(150, 50),
    Size(300, 100),
  ];
  group('Minimize square', () {
    testStrategyIsConsistent(
      'Minimize square strategy is consistent',
      strategy: mso.strategy,
      scenarios: [
        [
          mso.Parameters(preferredWidth: 100, preferredHeight: 100, badnessMultiplierHeight: 2),
        ],
        [
          mso.Parameters(preferredWidth: 100, preferredHeight: 100),
          mso.Parameters(preferredWidth: 100, preferredHeight: 100),
        ],
        [
          mso.Parameters(preferredWidth: 1000, preferredHeight: 10, badnessMultiplierHeight: 100, badnessMultiplierWidth: 12),
          mso.Parameters(preferredWidth: 1000, preferredHeight: 10, badnessMultiplierHeight: 10, badnessMultiplierWidth: 15),
        ],
        [
          mso.Parameters(preferredWidth: 1000, preferredHeight: 10),
          mso.Parameters(preferredWidth: 10, preferredHeight: 1000),
        ],
        [
          mso.Parameters(preferredWidth: 100, preferredHeight: 100),
          mso.Parameters(preferredWidth: 100, preferredHeight: 100),
          mso.Parameters(preferredWidth: 100, preferredHeight: 200),
        ],
        [
          mso.Parameters(preferredWidth: 104, preferredHeight: 51),
          mso.Parameters(preferredWidth: 10, preferredHeight: 38),
          mso.Parameters(preferredWidth: 475, preferredHeight: 712),
          mso.Parameters(preferredWidth: 232, preferredHeight: 514, badnessMultiplierHeight: 5),
          mso.Parameters(preferredWidth: 740, preferredHeight: 84, badnessMultiplierHeight: 6, badnessMultiplierWidth: 13),
          mso.Parameters(preferredWidth: 143, preferredHeight: 115, badnessMultiplierHeight: 4, badnessMultiplierWidth: 17),
        ],
      ],
      sizes: sizesToTry,
      checkWidthsPositive: false,
    );
    testLayoutOptimizer('2 children perfectly in column', 100, 200, mso.strategy, [
      TestableWidget(
        parameters: mso.Parameters(
          preferredWidth: 100,
          preferredHeight: 100,
        ),
        expectedWidth: 100,
        expectedHeight: 100,
      ),
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100)
    ]);
    testLayoutOptimizer('2 children different sizes perfectly in column', 100, 300, mso.strategy, [
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 200),
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100)
    ]);
    testLayoutOptimizer('2 too big children in column', 100, 300, mso.strategy, [
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 150),
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 150)
    ]);
    testLayoutOptimizer('3 children in row', 300, 100, mso.strategy, [
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100),
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100),
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100)
    ]);
    testLayoutOptimizer('3 children in column in row perfectly', 100, 100, mso.strategy, [
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 50,
            preferredHeight: 100,
          ),
          expectedWidth: 50,
          expectedHeight: 100),
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 50,
            preferredHeight: 50,
          ),
          expectedWidth: 50,
          expectedHeight: 50),
      TestableWidget(
          parameters: mso.Parameters(
            preferredWidth: 50,
            preferredHeight: 50,
          ),
          expectedWidth: 50,
          expectedHeight: 50)
    ]);
  });
  group('Inverted', () {
    testStrategyIsConsistent(
      'Inverted strategy is consistent',
      strategy: inv.strategy,
      scenarios: [
        [
          inv.Parameters(preferredWidth: 100, preferredHeight: 100),
        ],
        [
          inv.Parameters(preferredWidth: 100, preferredHeight: 100),
          inv.Parameters(preferredWidth: 100, preferredHeight: 100),
        ],
        [
          inv.Parameters(preferredWidth: 1000, preferredHeight: 10),
          inv.Parameters(preferredWidth: 1000, preferredHeight: 10),
        ],
        [
          inv.Parameters(preferredWidth: 1000, preferredHeight: 10),
          inv.Parameters(preferredWidth: 10, preferredHeight: 1000),
        ],
        [
          inv.Parameters(preferredWidth: 100, preferredHeight: 100),
          inv.Parameters(preferredWidth: 100, preferredHeight: 100),
          inv.Parameters(preferredWidth: 100, preferredHeight: 200),
        ],
        [
          inv.Parameters(preferredWidth: 104, preferredHeight: 51),
          inv.Parameters(preferredWidth: 10, preferredHeight: 38),
          inv.Parameters(preferredWidth: 475, preferredHeight: 712),
          inv.Parameters(preferredWidth: 232, preferredHeight: 514),
          inv.Parameters(preferredWidth: 740, preferredHeight: 84),
          inv.Parameters(preferredWidth: 143, preferredHeight: 115),
        ],
      ],
      sizes: sizesToTry,
    );
    testLayoutOptimizer('2 children perfectly in column', 100, 200, inv.strategy, [
      TestableWidget(
        parameters: inv.Parameters(
          preferredWidth: 100,
          preferredHeight: 100,
        ),
        expectedWidth: 100,
        expectedHeight: 100,
      ),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100)
    ]);
    testLayoutOptimizer('2 children different sizes perfectly in column', 100, 300, inv.strategy, [
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 200),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100)
    ]);
    testLayoutOptimizer('2 too big children in column', 100, 300, inv.strategy, [
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 150),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 150)
    ]);
    testLayoutOptimizer('2 too large children in column', 100, 100, inv.strategy, [
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 1000,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 50),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 1000,
            preferredHeight: 200,
          ),
          expectedWidth: 100,
          expectedHeight: 50)
    ]);
    testLayoutOptimizer('3 children in row', 300, 100, inv.strategy, [
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 100,
          ),
          expectedWidth: 100,
          expectedHeight: 100)
    ]);
    testLayoutOptimizer('3 children in column in row perfectly', 100, 100, inv.strategy, [
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 50,
            preferredHeight: 100,
          ),
          expectedWidth: 50,
          expectedHeight: 100),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 50,
            preferredHeight: 50,
          ),
          expectedWidth: 50,
          expectedHeight: 50),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 50,
            preferredHeight: 50,
          ),
          expectedWidth: 50,
          expectedHeight: 50)
    ]);
    testLayoutOptimizer('3 too small children in row in column', 10, 10, inv.strategy, [
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 100,
            preferredHeight: 50,
          ),
          expectedWidth: 10,
          expectedHeight: 5),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 50,
            preferredHeight: 50,
          ),
          expectedWidth: 5,
          expectedHeight: 5),
      TestableWidget(
          parameters: inv.Parameters(
            preferredWidth: 50,
            preferredHeight: 50,
          ),
          expectedWidth: 5,
          expectedHeight: 5)
    ]);
  });
}
