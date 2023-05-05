import 'package:flutter/material.dart';
import 'package:rpn_calculator/combinatorics.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';

OptimizationStrategy<Parameters> get strategy => OptimizationStrategy<Parameters>(
      calculateBadnessForSize: calculateBadnessForSize,
      getOptimalWidths: getOptimalWidths,
      getParametersOfRow: getParametersOfRow,
    );

double calculateBadnessForSize(Parameters parameters, Size size) => parameters.badnessCoefficients.width / size.width + parameters.badnessCoefficients.height / size.height + parameters.constantBadness;

List<double> getOptimalWidths(List<Parameters> parametersChildren, Size confinement) {
  final sumSqrts = parametersChildren.sum((child) => child.badnessCoefficients.width.sqrt);
  return parametersChildren.map((child) => confinement.width * child.badnessCoefficients.width.sqrt / sumSqrts).toList();
}

Parameters getParametersOfRow(List<Parameters> parametersChildren) {
  return Parameters._fromRaw(
    badnessCoefficients: Size(
      parametersChildren.sum((child) => child.badnessCoefficients.width.sqrt).squared,
      parametersChildren.sum((child) => child.badnessCoefficients.height),
    ),
    constantBadness: parametersChildren.sum((child) => child.constantBadness),
  );
}

class Parameters extends OptimizationParameters<Parameters> {
  final Size badnessCoefficients;
  final double constantBadness;

  Parameters({
    required double preferredWidth,
    required double preferredHeight,
    this.constantBadness = 0,
  }) : badnessCoefficients = Size(preferredWidth.squared, preferredHeight.squared);

  Parameters._fromRaw({required this.badnessCoefficients, required this.constantBadness});

  @override
  Parameters get transposed => Parameters._fromRaw(
        badnessCoefficients: badnessCoefficients.flipped,
        constantBadness: constantBadness,
      );
}
