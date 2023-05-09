import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';
import 'test_functions.dart';

@isTest
void testStrategyProperties<TParameters extends OptimizationParameters<TParameters>>(
  String description,
  OptimizationStrategy<TParameters> strategy,
  List<StrategyPropertiy> propertiesToTest,
  OptimizableProducer<TParameters> optimizableProducer,
) {
  if (propertiesToTest.any((propertie) => !propertie.producerIsSufficient(optimizableProducer))) {
    throw ArgumentError('Choosen properties require producer functions not present in the producer.');
  }

  testWidgets(
    description,
    (tester) async {
      addTearDown(tester.binding.window.clearAllTestValues);

      final tests = _getTests<TParameters>().where((test) => test.propertiesNeeded.every((property) => propertiesToTest.contains(property))).toList();

      for (final test in tests) {
        Size screenSize = Size(test.screenWidth, test.screenHeight);
        tester.binding.window.physicalSizeTestValue = screenSize;
        await tester.binding.setSurfaceSize(screenSize);
        tester.binding.window.devicePixelRatioTestValue = 1;

        List<TestableWidget<TParameters>> children = test.produceResult(optimizableProducer);
        await tester.pumpWidget(
          MaterialApp(
            home: LayoutOptimizer(
              strategy: strategy,
              children: children.map((c) => c.optimizable).toList(),
            ),
          ),
        );

        int iChild = 0;
        for (TestableWidget child in children) {
          final evaluated = find.byWidget(child.optimizable).evaluate();

          if (evaluated.length != 1) {
            test.failureDescriptions.add('Child $iChild was rendered ${evaluated.length} times.');
          }
          final size = evaluated.single.size!;
          if (size.width != child.expectedWidth) {
            test.failureDescriptions.add('Child $iChild had width ${size.width} but width ${child.expectedWidth} was expected.');
          }
          if (size.height != child.expectedHeight) {
            test.failureDescriptions.add('Child $iChild had height ${size.height} but height ${child.expectedHeight} was expected.');
          }
          iChild++;
        }
      }

      final failedTests = tests.where((test) => !test.passed).toList();
      if (failedTests.isNotEmpty) {
        fail('Not every test allowed by the properties passed. All failed tests tested the properties ${StrategyPropertiy.values.where((property) => failedTests.every((test) => test.propertiesNeeded.contains(property))).map((property) => property.name).toList()}. Failed tests are listed below, loosely ordered by importance.\n\n${failedTests.join('\n\n')}');
      }
    },
  );
}

enum StrategyPropertiy {
  perfectFitInLine(requireFromPreferred: true),
  perfectFitAlways(requireFromPreferred: true),
  similarBetweenTransposedStates(requireFromPreferred: true),
  scalesWithScreen();

  final bool requireFromPreferred;

  const StrategyPropertiy({this.requireFromPreferred = false});

  bool producerIsSufficient<TParameters extends OptimizationParameters<TParameters>>(OptimizableProducer<TParameters> producer) {
    if (requireFromPreferred && producer.fromPrefferedSize == null) {
      return false;
    }
    return true;
  }
}

class _TestOfProperties<TParameters extends OptimizationParameters<TParameters>> {
  final String description;
  final double screenWidth;
  final double screenHeight;
  final List<TestableWidget<TParameters>> Function(OptimizableProducer<TParameters>) produceResult;
  final List<StrategyPropertiy> propertiesNeeded;
  final List<String> failureDescriptions = [];

  _TestOfProperties({
    required this.description,
    required this.screenWidth,
    required this.screenHeight,
    required this.produceResult,
    required this.propertiesNeeded,
  });

  bool get passed => failureDescriptions.isEmpty;

  @override
  String toString() => 'Description: $description\nFailures:\n  ${failureDescriptions.join('\n  ')}\nProperties tested:\n  ${propertiesNeeded.map((property) => property.name).join('\n  ')}\nScreen width: $screenWidth\nScreen height: $screenHeight';
}

class OptimizableProducer<TParameters extends OptimizationParameters<TParameters>> {
  final TParameters Function(double, double)? fromPrefferedSize;
  OptimizableProducer({required this.fromPrefferedSize});
}

List<_TestOfProperties<TParameters>> _getTests<TParameters extends OptimizationParameters<TParameters>>() => [
      _TestOfProperties<TParameters>(
        description: 'One square fitting perfectly.',
        screenWidth: 100,
        screenHeight: 100,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 100,
            expectedHeight: 100,
          ),
        ],
        propertiesNeeded: [],
      ),
      _TestOfProperties(
        description: 'One child too small and too tall.',
        screenWidth: 200,
        screenHeight: 50,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 200,
            expectedHeight: 50,
          ),
        ],
        propertiesNeeded: [],
      ),
      _TestOfProperties(
        description: 'Two squares perfectly in column.',
        screenWidth: 100,
        screenHeight: 200,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 100,
            expectedHeight: 100,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 100,
            expectedHeight: 100,
          ),
        ],
        propertiesNeeded: [
          StrategyPropertiy.perfectFitInLine,
        ],
      ),
      _TestOfProperties(
        description: '2 children different sizes perfectly in column',
        screenWidth: 100,
        screenHeight: 300,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 200),
            expectedWidth: 100,
            expectedHeight: 200,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 100,
            expectedHeight: 100,
          )
        ],
        propertiesNeeded: [
          StrategyPropertiy.perfectFitInLine,
        ],
      ),
      _TestOfProperties(
        description: '3 children in row',
        screenWidth: 300,
        screenHeight: 100,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 100,
            expectedHeight: 100,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 100,
            expectedHeight: 100,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 100),
            expectedWidth: 100,
            expectedHeight: 100,
          ),
        ],
        propertiesNeeded: [
          StrategyPropertiy.perfectFitInLine,
        ],
      ),
      _TestOfProperties(
        description: '3 children in column in row perfectly.',
        screenWidth: 100,
        screenHeight: 100,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(50, 100),
            expectedWidth: 50,
            expectedHeight: 100,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(50, 50),
            expectedWidth: 50,
            expectedHeight: 50,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(50, 50),
            expectedWidth: 50,
            expectedHeight: 50,
          ),
        ],
        propertiesNeeded: [
          StrategyPropertiy.perfectFitAlways,
        ],
      ),
      _TestOfProperties(
        description: 'Three children in row and column in a too small space.',
        screenWidth: 10,
        screenHeight: 10,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(100, 50),
            expectedWidth: 10,
            expectedHeight: 5,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(50, 50),
            expectedWidth: 5,
            expectedHeight: 5,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(50, 50),
            expectedWidth: 5,
            expectedHeight: 5,
          ),
        ],
        propertiesNeeded: [
          StrategyPropertiy.perfectFitAlways,
          StrategyPropertiy.scalesWithScreen,
        ],
      ),
      _TestOfProperties(
        description: '2 too tall and wide children in column.',
        screenWidth: 100,
        screenHeight: 100,
        produceResult: (producer) => [
          TestableWidget(
            parameters: producer.fromPrefferedSize!(1000, 200),
            expectedWidth: 100,
            expectedHeight: 50,
          ),
          TestableWidget(
            parameters: producer.fromPrefferedSize!(1000, 200),
            expectedWidth: 100,
            expectedHeight: 50,
          ),
        ],
        propertiesNeeded: [
          StrategyPropertiy.similarBetweenTransposedStates,
        ],
      ),
    ];
