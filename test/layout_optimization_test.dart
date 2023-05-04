import 'package:rpn_calculator/layout_optimization/minimize_square_optimizer.dart' as mso;
import 'test_functions.dart';

void main() {
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
  testLayoutOptimizer('2 too small children in column', 100, 300, mso.strategy, [
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
  testLayoutOptimizer('2 too large children in column', 100, 100, mso.strategy, [
    TestableWidget(
        parameters: mso.Parameters(
          preferredWidth: 1000,
          preferredHeight: 200,
        ),
        expectedWidth: 100,
        expectedHeight: 50),
    TestableWidget(
        parameters: mso.Parameters(
          preferredWidth: 1000,
          preferredHeight: 200,
        ),
        expectedWidth: 100,
        expectedHeight: 50)
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
  testLayoutOptimizer('3 too small children in row in column', 10, 10, mso.strategy, [
    TestableWidget(
        parameters: mso.Parameters(
          preferredWidth: 100,
          preferredHeight: 50,
        ),
        expectedWidth: 10,
        expectedHeight: 5),
    TestableWidget(
        parameters: mso.Parameters(
          preferredWidth: 50,
          preferredHeight: 50,
        ),
        expectedWidth: 5,
        expectedHeight: 5),
    TestableWidget(
        parameters: mso.Parameters(
          preferredWidth: 50,
          preferredHeight: 50,
        ),
        expectedWidth: 5,
        expectedHeight: 5)
  ]);
}
