import 'package:rpn_calculator/layout_optimization/minimize_square_optimizable.dart';

import 'test_functions.dart';

void main() {
  testMinimizeSquareOptimizer('2 children perfectly in column', 100, 200, [
    TestableWidget(
      parameters: LeastSquareParameters(
        preferredWidth: 100,
        preferredHeight: 100,
      ),
      expectedWidth: 100,
      expectedHeight: 100,
    ),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 100,
        ),
        expectedWidth: 100,
        expectedHeight: 100)
  ]);
  testMinimizeSquareOptimizer('2 children different sizes perfectly in column', 100, 300, [
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 200,
        ),
        expectedWidth: 100,
        expectedHeight: 200),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 100,
        ),
        expectedWidth: 100,
        expectedHeight: 100)
  ]);
  testMinimizeSquareOptimizer('2 too small children in column', 100, 300, [
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 200,
        ),
        expectedWidth: 100,
        expectedHeight: 150),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 200,
        ),
        expectedWidth: 100,
        expectedHeight: 150)
  ]);
  testMinimizeSquareOptimizer('2 too large children in column', 100, 100, [
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 1000,
          preferredHeight: 200,
        ),
        expectedWidth: 100,
        expectedHeight: 50),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 1000,
          preferredHeight: 200,
        ),
        expectedWidth: 100,
        expectedHeight: 50)
  ]);
  testMinimizeSquareOptimizer('3 children in row', 300, 100, [
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 100,
        ),
        expectedWidth: 100,
        expectedHeight: 100),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 100,
        ),
        expectedWidth: 100,
        expectedHeight: 100),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 100,
        ),
        expectedWidth: 100,
        expectedHeight: 100)
  ]);
  testMinimizeSquareOptimizer('3 children in column in row perfectly', 100, 100, [
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 50,
          preferredHeight: 100,
        ),
        expectedWidth: 50,
        expectedHeight: 100),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 50,
          preferredHeight: 50,
        ),
        expectedWidth: 50,
        expectedHeight: 50),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 50,
          preferredHeight: 50,
        ),
        expectedWidth: 50,
        expectedHeight: 50)
  ]);
  testMinimizeSquareOptimizer('3 too small children in row in column', 10, 10, [
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 100,
          preferredHeight: 50,
        ),
        expectedWidth: 10,
        expectedHeight: 5),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 50,
          preferredHeight: 50,
        ),
        expectedWidth: 5,
        expectedHeight: 5),
    TestableWidget(
        parameters: LeastSquareParameters(
          preferredWidth: 50,
          preferredHeight: 50,
        ),
        expectedWidth: 5,
        expectedHeight: 5)
  ]);
}
