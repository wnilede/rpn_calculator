import 'package:flutter_test/flutter_test.dart';
import 'package:rpn_calculator/number_presentation.dart';

void mockSetState(void Function() function) => function();

void main() {
  group('fromDouble', () {
    test('Positive integer', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(7934512);
      expect(presentation.exponent, null);
      expect(presentation.mainPart, '7934512');
    });
    test('Negative integer', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(-7934512);
      expect(presentation.exponent, null);
      expect(presentation.mainPart, '-7934512');
    });
    test('Decimal number', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(7934.512);
      expect(presentation.exponent, null);
      expect(presentation.mainPart, '7934.512');
    });
    test('Large number', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(2893756298374652);
      expect(presentation.exponent, '15');
      expect(presentation.mainPart, '2.893756298');
    });
    test('Small number', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(0.00000000000002893756298374652);
      expect(presentation.exponent, '-14');
      expect(presentation.mainPart, '2.893756298');
    });
    test('Slightly smaller than 1', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(0.02893756298374652);
      expect(presentation.exponent, null);
      expect(presentation.mainPart, '0.028937563');
    });
    test('Number ending in 0', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(140000);
      expect(presentation.exponent, null);
      expect(presentation.mainPart, '140000');
    });
    test('Round up 9', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(1234567899.5);
      expect(presentation.exponent, null);
      expect(presentation.mainPart, '1234567900');
    });
    test('0', () {
      NumberPresentation presentation = NumberPresentation.fromDouble(0);
      expect(presentation.exponent, null);
      expect(presentation.mainPart, '0');
    });
  });
}
