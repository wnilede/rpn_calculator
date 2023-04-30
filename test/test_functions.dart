import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rpn_calculator/layout_optimization.dart';
import 'package:meta/meta.dart';

@isTest
void testLayoutOptimizer(String description, double screenWidth, double screenHeight, List<TestableWidget> children) {
  testWidgets(
    description,
    (tester) async {
      tester.binding.window.physicalSizeTestValue = Size(screenWidth, screenHeight);
      await tester.pumpWidget(
        MaterialApp(
          home: LayoutOptimizer(children: children.map((c) => c.optimizable).toList()),
        ),
      );
      int i = 0;
      for (TestableWidget child in children) {
        final evaluated = find.byWidget(child.optimizable).evaluate().single;
        expect(evaluated.size!.width, child.expectedWidth, reason: 'Child $i had not the expected width.');
        expect(evaluated.size!.height, child.expectedHeight, reason: 'Child $i had not the expected height.');
        i++;
      }
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    },
  );
}

class TestableWidget {
  final Optimizable optimizable;
  final double expectedWidth;
  final double expectedHeight;

  TestableWidget({
    required double preferredWidth,
    required double preferredHeight,
    double? badnessMultiplierWidth,
    double? badnessMultiplierHeight,
    required this.expectedWidth,
    required this.expectedHeight,
  }) : optimizable = Optimizable(
          preferredWidth: preferredWidth,
          preferredHeight: preferredHeight,
          badnessMultiplierWidth: badnessMultiplierWidth,
          badnessMultiplierHeight: badnessMultiplierHeight,
          child: Placeholder(),
        );
}
