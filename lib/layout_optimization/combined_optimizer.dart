import 'package:flutter/material.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';

// Optimizes by using different rules in different situations. Functions that determine which rules to use must be provided.
OptimizationStrategy<Parameters> getStrategy(
  List<double Function(OptimizationParameters parameters, Size size)> calculateBadnessForSize,
  List<List<double> Function(List<OptimizationParameters> parametersChildren, Size confinement)> getOptimalWidths,
  List<OptimizationParameters Function(List<OptimizationParameters> parametersChildren)> getParametersOfRow,
  List<OptimizationStrategy<dynamic>> strategies,
  int Function(OptimizationParameters parameters, Size size) methodForCalculateBadnessForSize,
  int Function(List<OptimizationParameters> parametersChildren, Size confinement) methodForGetOptimalWidths,
) =>
    OptimizationStrategy<Parameters>(
      calculateBadnessForSize: (parameters, size) => calculateBadnessForSize[methodForCalculateBadnessForSize(parameters, size)](parameters, size),
      getOptimalWidths: (parametersChildren, confinement) => getOptimalWidths[methodForGetOptimalWidths(parametersChildren, confinement)](parametersChildren, confinement),
      getParametersOfRow: (parametersChildren) => Parameters(getParametersOfRow.map((func) => func(parametersChildren)).toList()),
    );

class Parameters extends OptimizationParameters<Parameters> {
  final List<OptimizationParameters<dynamic>> parameters;

  Parameters(this.parameters);

  @override
  Parameters get transposed => Parameters(parameters.map((p) => p.transposed as OptimizationParameters<dynamic>).toList());
}
