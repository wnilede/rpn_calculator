import 'package:flutter/material.dart';
import 'package:rpn_calculator/constants.dart';
import 'buttons.dart';
import 'calculator_stack.dart';
import 'layout_optimization/layout_optimizer.dart';
import 'layout_optimization/minimize_square_optimizer.dart' as mso;
import 'stack_view.dart';
import 'fundamental_operations.dart';
import 'trigonometric_functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalculatorStack _stack;

  _MyHomePageState() : _stack = CalculatorStack();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutOptimizer(
        strategy: mso.strategy,
        children: [
          Optimizable(
            parameters: mso.Parameters(
              preferredWidth: 400,
              preferredHeight: 150,
              badnessMultiplierHeight: 10,
            ),
            child: AnimatedBuilder(
              animation: _stack,
              builder: (context, child) => StackView(stack: _stack, numStackEntriesShown: 4),
            ),
          ),
          Optimizable(
            parameters: mso.Parameters(
              preferredWidth: 180,
              preferredHeight: 240,
            ),
            child: DigitTable(stack: _stack),
          ),
          Optimizable(
            parameters: mso.Parameters(
              preferredWidth: 120,
              preferredHeight: 120,
            ),
            child: FundamentalOperations(stack: _stack),
          ),
          Optimizable(
            parameters: mso.Parameters(
              preferredWidth: 150,
              preferredHeight: 50,
            ),
            child: TrigonometricFunctions(stack: _stack),
          ),
          Optimizable(
            parameters: mso.Parameters(
              preferredWidth: 100,
              preferredHeight: 50,
            ),
            child: Constants(stack: _stack),
          )
        ],
      ),
    );
  }
}
