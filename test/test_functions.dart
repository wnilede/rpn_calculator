import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rpn_calculator/combinatorics.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';
import 'package:meta/meta.dart';

@isTest
void testLayoutOptimizer<TParameters extends OptimizationParameters<TParameters>>(String description, double screenWidth, double screenHeight, OptimizationStrategy<TParameters> strategy, List<TestableWidget<TParameters>> children) {
  testWidgets(
    description,
    (tester) async {
      Size screenSize = Size(screenWidth, screenHeight);
      tester.binding.window.physicalSizeTestValue = screenSize;
      await tester.binding.setSurfaceSize(screenSize);
      tester.binding.window.devicePixelRatioTestValue = 1;
      await tester.pumpWidget(
        MaterialApp(
          home: LayoutOptimizer(
            strategy: strategy,
            children: children.map((c) => c.optimizable).toList(),
          ),
        ),
      );
      int i = 0;
      for (TestableWidget child in children) {
        final evaluated = find.byWidget(child.optimizable).evaluate();
        if (evaluated.length != 1) {
          fail('Child $i was rendered ${evaluated.length} times.');
        }
        expect(evaluated.single.size!.width, child.expectedWidth, reason: 'Child $i had not the expected width.');
        expect(evaluated.single.size!.height, child.expectedHeight, reason: 'Child $i had not the expected height.');
        i++;
      }
      addTearDown(tester.binding.window.clearAllTestValues);
    },
  );
}

class TestableWidget<TParameters extends OptimizationParameters<TParameters>> {
  final Optimizable<TParameters> optimizable;
  final double expectedWidth;
  final double expectedHeight;

  TestableWidget({
    required TParameters parameters,
    required this.expectedWidth,
    required this.expectedHeight,
  }) : optimizable = Optimizable<TParameters>(
          parameters: parameters,
          child: Placeholder(),
        );
}

@isTest
void testStrategyIsConsistent<TParameters extends OptimizationParameters<TParameters>>(
  String description, {
  required OptimizationStrategy<TParameters> strategy,
  required List<List<TParameters>> scenarios,
  required List<Size> sizes,
  bool checkOptimalWidthLength = true,
  bool checkWidthsPositive = true,
  bool checkWidthsSumToTotal = true,
  bool checkBadnessSumOfChildren = true,
  bool checkBadnessIsMinimized = true,
}) {
  test(
    description,
    () {
      for (List<TParameters> parametersChildren in scenarios) {
        final parameterRow = strategy.getParametersOfRow(parametersChildren);
        for (Size size in sizes) {
          final optimalWidths = strategy.getOptimalWidths(parametersChildren, size);
          final minimalBadness = strategy.calculateBadnessForSize(parameterRow, size);

          final positionDescriber = '\nsize:\n  width: ${size.width}\n  height: ${size.height}\nscenario:\n  index: ${scenarios.indexOf(parametersChildren)}\n  length: ${parametersChildren.length}\n  children:\n    ${parametersChildren.join('\n    ')}\ncalculated values:\n  parameterRow: $parameterRow\n  minimalBadness: $minimalBadness\n  optimalWidths:\n    ${optimalWidths.join('\n    ')}';

          if (checkOptimalWidthLength) {
            expect(
              optimalWidths.length,
              parametersChildren.length,
              reason: 'The lengths of the list returned by getOptimalWidths is not the same as the number of children.$positionDescriber',
            );
          }
          if (checkWidthsPositive) {
            expect(
              optimalWidths.every((width) => width > 0),
              isTrue,
              reason: 'The values returned by getOptimalWidths are not all positive.$positionDescriber',
            );
          }
          if (checkWidthsSumToTotal) {
            expect(
              optimalWidths.sum((width) => width),
              closeTo(size.width, size.width / 100000000000),
              reason: 'The sum of the values returned by getOptimalWidths does not equal the total width.$positionDescriber',
            );
          }

          if (checkBadnessSumOfChildren) {
            double sum = 0;
            for (int i = 0; i < parametersChildren.length; i++) {
              sum += strategy.calculateBadnessForSize(parametersChildren[i], Size(optimalWidths[i], size.height));
            }
            expect(
              sum,
              closeTo(minimalBadness, minimalBadness / 100000000000),
              reason: "The total badness is not the same as the sum of all the childrens' badnesses.$positionDescriber",
            );
          }

          if (checkBadnessIsMinimized) {
            for (int iDecreasing = 0; iDecreasing < parametersChildren.length; iDecreasing++) {
              for (int iIncreasing = 0; iIncreasing < parametersChildren.length; iIncreasing++) {
                if (iDecreasing == iIncreasing || optimalWidths[iDecreasing] == 0) {
                  continue;
                }
                final diff = math.min(optimalWidths[iDecreasing], optimalWidths[iIncreasing]) / 100;
                double sumAlternative = 0;
                for (int iSum = 0; iSum < parametersChildren.length; iSum++) {
                  double width = optimalWidths[iSum];
                  if (iSum == iIncreasing) {
                    width += diff;
                  }
                  if (iSum == iDecreasing) {
                    width -= diff;
                  }
                  sumAlternative += strategy.calculateBadnessForSize(
                    parametersChildren[iSum],
                    Size(width, size.height),
                  );
                }
                expect(
                  sumAlternative,
                  greaterThanOrEqualTo(minimalBadness),
                  reason: 'The badness was not minimized when arranged according to getOptimalWidths, because it was smaller when child $iDecreasing was slightly smaller and child $iIncreasing slightly wider.$positionDescriber',
                );
              }
            }
          }
        }
      }
    },
  );
}
