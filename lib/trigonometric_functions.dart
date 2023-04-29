import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rpn_calculator/calculator_stack.dart';
import 'buttons.dart';

class TrigonometricFunctions extends StatelessWidget {
  final CalculatorStack stack;

  const TrigonometricFunctions({required this.stack, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Button(
          label: 'sin',
          effect: () => stack.applyOnOne((x) => math.sin(x)),
        ),
        Button(
          label: 'cos',
          effect: () => stack.applyOnOne((x) => math.cos(x)),
        ),
        Button(
          label: 'tan',
          effect: () => stack.applyOnOne((x) => math.tan(x)),
        ),
      ],
    );
  }
}
