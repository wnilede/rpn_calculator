import 'dart:math' as math;

class NumberPresentation {
  late final String mainPart;
  late final String? exponent;

  NumberPresentation(this.mainPart, this.exponent);
  NumberPresentation.empty()
      : mainPart = '',
        exponent = null;
  NumberPresentation.fromDouble(double value) {
    // Absolute zero is handled separately.
    if (value == 0) {
      mainPart = '0';
      exponent = null;
      return;
    }

    // This is used to build the main part.
    String mainPartInContruction = '';

    // We parse the value as if it was positive and add a minus in front if it was negative.
    if (value < 0) {
      mainPartInContruction += '-';
    }
    value = value.abs();

    // If the first digit has position > 10 or < -5, we use scientific notation. In this case, we determine the exponent.
    int power = (math.log(value) * math.log10e).floor();
    if (-5 < power && power < 10) {
      power = 0;
    }
    exponent = power == 0 ? null : '$power';

    // Modify value and power to reflect the new exponent.
    value *= math.pow(10, -power);
    power = math.max((math.log(value) * math.log10e).floor(), 0);

    // Round value to the appropriate accuracy.
    mainPartInContruction += value.toStringAsFixed(9 - power);

    // Remove zeroes after decimal point.
    if (mainPartInContruction.contains('.')) {
      mainPartInContruction = mainPartInContruction.replaceFirst(RegExp(r'\.?0*$'), '');
    }

    // Set the actual field to the finished local variable
    mainPart = mainPartInContruction;
  }

  bool get isEmpty => mainPart == '' && exponent == null;
  int get numberOfDigits => RegExp(r'\d').allMatches(mainPart).length;
  double toDouble() => double.parse(mainPart) * (exponent == null ? 1 : math.pow(10, int.parse(exponent!)));
  NumberPresentation copyWith({String? mainPart, String? exponent}) => NumberPresentation(mainPart ?? this.mainPart, exponent ?? this.exponent);
}
