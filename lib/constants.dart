import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:rpn_calculator/calculator_stack.dart';
import 'buttons.dart';

class Constants extends StatelessWidget {
  final CalculatorStack stack;

  const Constants({required this.stack, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Button(
          label: 'pi',
          effect: () => stack.push(math.pi),
        ),
        Button(
          label: 'e',
          effect: () => stack.push(math.e),
        )
      ],
    );
  }
}
