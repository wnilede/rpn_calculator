import 'package:flutter/material.dart';
import 'package:rpn_calculator/calculator_stack.dart';
import 'package:rpn_calculator/number_presentation.dart';

class StackView extends StatelessWidget {
  final CalculatorStack stack;
  final int numStackEntriesShown;

  const StackView({
    required this.stack,
    required this.numStackEntriesShown,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<StackItem> stackItems = [];
    if (!stack.currentInput.isEmpty) {
      stackItems.add(StackItem(
        index: 0,
        child: StackItemValue.fromNumberPresentation(stack.currentInput),
      ));
    }
    for (int i = 0; i < stack.length; i++) {
      stackItems.add(StackItem(
        index: stackItems.length,
        child: StackItemValue.fromDouble(stack[i]),
      ));
      if (stackItems.length == numStackEntriesShown) {
        break;
      }
    }
    while (stackItems.length < numStackEntriesShown) {
      stackItems.add(StackItem(index: stackItems.length));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: stackItems.reversed.toList(),
    );
  }
}

class StackItem extends StatelessWidget {
  const StackItem({required this.index, this.child, super.key});

  final int index;
  final Widget? child;

  static String indexLabel(int index) {
    if (index == 0) {
      return 'x';
    }
    if (index == 1) {
      return 'y';
    }
    if (index == 2) {
      return 'z';
    }
    return (index + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${indexLabel(index)}:',
            style: theme.textTheme.headlineSmall,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class StackItemValue extends StatelessWidget {
  const StackItemValue(this.mainText, {this.exponentText, super.key});
  StackItemValue.fromNumberPresentation(NumberPresentation? presentation, {super.key})
      : exponentText = presentation?.exponent,
        mainText = presentation == null ? '' : presentation.mainPart;
  StackItemValue.fromDouble(double value, {key}) : this.fromNumberPresentation(NumberPresentation.fromDouble(value), key: key);

  final String? exponentText;
  final String mainText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            mainText,
            style: theme.textTheme.headlineMedium,
          ),
          if (exponentText != null)
            Column(
              children: [
                Text(
                  exponentText!,
                  style: theme.textTheme.labelLarge,
                ),
                Text(
                  'x10',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
