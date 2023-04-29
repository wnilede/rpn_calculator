import 'package:flutter/material.dart';
import 'package:rpn_calculator/calculator_stack.dart';

class DigitTable extends StatelessWidget {
  final CalculatorStack stack;

  const DigitTable({required this.stack, super.key});

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
              DigitButton(7, stack),
              DigitButton(8, stack),
              DigitButton(9, stack),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DigitButton(4, stack),
              DigitButton(5, stack),
              DigitButton(6, stack),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DigitButton(1, stack),
              DigitButton(2, stack),
              DigitButton(3, stack),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Button(
                label: '.',
                effect: stack.enterDecimalPoint,
              ),
              DigitButton(0, stack),
              Button(
                symbol: const Icon(Icons.keyboard_return_rounded),
                effect: stack.pressEnterButton,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Button extends StatelessWidget {
  final void Function() effect;
  final String? label;
  final Widget? symbol;

  const Button({required this.effect, this.label, this.symbol, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          onPressed: effect,
          child: symbol ?? (label == null ? null : Text(label!)),
        ),
      ),
    );
  }
}

class DigitButton extends StatelessWidget {
  final int digit;
  final CalculatorStack stack;

  const DigitButton(this.digit, this.stack, {super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      effect: () => stack.enterDigit(digit),
      label: digit.toString(),
    );
  }
}

class NormalButton extends StatelessWidget {
  final String label;
  final List<double> Function(List<double>) stackEffect;
  final void Function(List<double>) setStack;

  const NormalButton({required this.label, required this.stackEffect, required this.setStack, super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      label: label,
      effect: () {},
    );
  }
}
