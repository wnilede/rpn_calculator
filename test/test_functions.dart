import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';
import 'package:meta/meta.dart';
import 'package:rpn_calculator/layout_optimization/minimize_square_optimizable.dart';

@isTest
void testMinimizeSquareOptimizer(String description, double screenWidth, double screenHeight, List<TestableWidget<LeastSquareParameters>> children) {
  testWidgets(
    description,
    (tester) async {
      Size screenSize = Size(screenWidth, screenHeight);
      tester.binding.window.physicalSizeTestValue = screenSize;
      await tester.binding.setSurfaceSize(screenSize);
      tester.binding.window.devicePixelRatioTestValue = 1;
      await tester.pumpWidget(
        MaterialApp(
          home: LeastSquareLayout(children: children.map((c) => c.optimizable).toList()),
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
