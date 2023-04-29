import 'package:flutter_test/flutter_test.dart';
import 'package:rpn_calculator/calculator_stack.dart';

void mockSetState(void Function() function) => function();

void main() {
  test('Simple operation on two', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(4);
    stack.pressEnterButton();
    stack.enterDigit(5);
    stack.applyOnTwo((x, y) => x + y);
    expectStack(stack, 9);
  });
  test('Assymetric operation on two', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(5);
    stack.pressEnterButton();
    stack.enterDigit(3);
    stack.applyOnTwo((x, y) => y - x);
    expectStack(stack, 2);
  });
  test('Write zero to stack', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(0);
    stack.pressEnterButton();
    stack.applyOnTwo((x, y) => x + y + 3);
    expectStack(stack, 3);
  });
  test('Multiple digit number', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(5);
    stack.enterDigit(3);
    stack.applyOnOne((x) => x + 3);
    expectStack(stack, 56);
  });
  test('More than 10 digit number', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(4);
    stack.enterDigit(5);
    stack.enterDigit(7);
    stack.enterDigit(5);
    stack.enterDigit(0);
    stack.enterDigit(1);
    stack.enterDigit(2);
    stack.enterDigit(7);
    stack.enterDigit(3);
    stack.enterDigit(1);
    stack.enterDigit(7);
    stack.applyOnOne((x) => x + 1);
    expectStack(stack, 4575012732);
  });
  test('Zero at beginning', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(0);
    stack.enterDigit(4);
    stack.enterDigit(5);
    stack.enterDigit(7);
    stack.enterDigit(5);
    stack.enterDigit(0);
    stack.enterDigit(1);
    stack.enterDigit(2);
    stack.enterDigit(7);
    stack.enterDigit(3);
    stack.enterDigit(1);
    stack.enterDigit(7);
    stack.applyOnOne((x) => x + 1);
    expectStack(stack, 4575012732);
  });
  test('Zero at end', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(4);
    stack.enterDigit(0);
    stack.applyOnOne((x) => x + 1);
    expectStack(stack, 41);
  });
  test('Zero at end after decimal point', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(4);
    stack.enterDigit(0);
    stack.enterDecimalPoint();
    stack.enterDigit(0);
    stack.applyOnOne((x) => x + 1);
    expectStack(stack, 41);
  });
  test('More than 10 digit number with decimal', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(4);
    stack.enterDigit(5);
    stack.enterDigit(7);
    stack.enterDigit(5);
    stack.enterDecimalPoint();
    stack.enterDigit(0);
    stack.enterDigit(1);
    stack.enterDigit(2);
    stack.enterDigit(7);
    stack.enterDigit(3);
    stack.enterDigit(1);
    stack.enterDigit(7);
    stack.applyOnOne((x) => x + 1);
    expectStack(stack, 4576.012731);
  });
  test('Decimal number', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(5);
    stack.enterDigit(3);
    stack.enterDecimalPoint();
    stack.enterDigit(1);
    stack.enterDigit(7);
    stack.applyOnOne((x) => x + 3);
    expectStack(stack, 56.17);
  });
  test('Decimal number without integer part', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDecimalPoint();
    stack.enterDigit(2);
    stack.enterDigit(5);
    stack.applyOnOne((x) => x + 3);
    expectStack(stack, 3.25);
  });
  test('Only decimal point', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDecimalPoint();
    stack.applyOnOne((x) => x + 2);
    expectStack(stack, 2);
  });
  test('Decimal point after enter', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(2);
    stack.pressEnterButton();
    stack.enterDecimalPoint();
    stack.enterDigit(3);
    stack.applyOnTwo((x, y) => x + y);
    expectStack(stack, 2.3);
  });
  test('Operation on two with larger stack', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(4);
    stack.pressEnterButton();
    stack.enterDigit(5);
    stack.pressEnterButton();
    stack.enterDigit(3);
    stack.pressEnterButton();
    stack.enterDigit(6);
    stack.applyOnTwo((x, y) => x + y);
    expectStack(stack, [
      9,
      5,
      4,
    ]);
  });
  test('Simple operation on one', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(4);
    stack.applyOnOne((x) => x + 3);
    expectStack(stack, 7);
  });
  test('Use copy by enter', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(2);
    stack.pressEnterButton();
    stack.applyOnOne((x) => x * 3);
    expectStack(stack, [
      6,
      2
    ]);
  });
  test('Use copy of result by enter', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(2);
    stack.applyOnOne((x) => x * 3);
    stack.pressEnterButton();
    stack.applyOnTwo((x, y) => x * y - 1);
    expectStack(stack, 35);
  });
  test('Use copy, applyOnTwo twice, and then enterDigit', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(2);
    stack.pressEnterButton();
    stack.applyOnTwo((x, y) => x + y);
    stack.applyOnTwo((x, y) => x + y);
    stack.enterDigit(3);
    expectStack(stack, [
      4
    ]);
  });
  test('Multiple operations', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(2);
    stack.pressEnterButton();
    stack.enterDigit(3);
    stack.pressEnterButton();
    stack.enterDigit(5);
    stack.applyOnTwo((x, y) => x + y);
    stack.enterDigit(7);
    stack.applyOnTwo((x, y) => x * y);
    stack.applyOnOne((x) => x + 1);
    stack.applyOnTwo((x, y) => x + y);
    expectStack(stack, 59);
  });
  test('Operation on two with one in stack', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.enterDigit(2);
    stack.applyOnTwo((x, y) => x + y);
    expectStack(stack, 2);
  });
  test('Operation on one with zero in stack', () {
    CalculatorStack stack = CalculatorStack(mockSetState);
    stack.applyOnOne((x) => x + 7);
    expectStack(stack, []);
  });
}

void expectStack(CalculatorStack stack, dynamic expected) {
  List expectedValues;
  if (expected is List) {
    expectedValues = expected;
  } else {
    expectedValues = [
      expected
    ];
  }
  if (stack.length != expectedValues.length) {
    fail('Stack has length ${stack.length} but length ${expectedValues.length} was expected');
  }
  for (int i = 0; i < stack.length; i++) {
    if ((stack[i] / expectedValues[i] - 1).abs() >= 0.0000000001) {
      fail('Stack at index $i is ${stack[i]} but expected value was ${expectedValues[i]}');
    }
  }
}
