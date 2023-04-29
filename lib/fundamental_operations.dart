import 'package:flutter/material.dart';
import 'package:rpn_calculator/calculator_stack.dart';
import 'buttons.dart';

class FundamentalOperations extends StatelessWidget {
  final CalculatorStack stack;

  const FundamentalOperations({required this.stack, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Button(
                label: '*',
                effect: () => stack.applyOnTwo((x, y) => x * y),
              ),
              Button(
                label: '/',
                effect: () => stack.applyOnTwo((x, y) => y / x),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Button(
                label: '+',
                effect: () => stack.applyOnTwo((x, y) => x + y),
              ),
              Button(
                label: '-',
                effect: () => stack.applyOnTwo((x, y) => y - x),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
