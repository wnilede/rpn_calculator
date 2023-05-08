import 'package:flutter/material.dart';
import 'package:rpn_calculator/combinatorics.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';

OptimizationStrategy<Parameters> get strategy => OptimizationStrategy<Parameters>(
      calculateBadnessForSize: calculateBadnessForSize,
      getOptimalWidths: getOptimalWidths,
      getParametersOfRow: getParametersOfRow,
    );

double calculateBadnessForSize(Parameters parameters, Size size) => parameters.badnessCoefficients.width * (size.width - parameters.preferredSize.width).squared + parameters.badnessCoefficients.height * (size.height - parameters.preferredSize.height).squared + parameters.constantBadness;

List<double> getOptimalWidths(List<Parameters> parametersChildren, Size confinement) {
  final sumInvertedCoefficients = parametersChildren.sum((child) => 1 / child.badnessCoefficients.width);
  final sumPreferred = parametersChildren.sum((child) => child.preferredSize.width);
  return parametersChildren.map((child) => child.preferredSize.width + (confinement.width - sumPreferred) / sumInvertedCoefficients / child.badnessCoefficients.width).toList();
}

Parameters getParametersOfRow(List<Parameters> parametersChildren) {
  assert(parametersChildren.isNotEmpty);
  if (parametersChildren.length == 1) {
    return parametersChildren[0];
  }
  final double sumCoefficientsHeight = parametersChildren.sum((child) => child.badnessCoefficients.height);
  final double sumCoefficientsTimesPreferredHeight = parametersChildren.sum((child) => child.badnessCoefficients.height * child.preferredSize.height);
  return Parameters._fromRaw(
    preferredSize: Size(
      parametersChildren.sum((child) => child.preferredSize.width),
      sumCoefficientsTimesPreferredHeight / sumCoefficientsHeight,
    ),
    badnessCoefficients: Size(
      1 / parametersChildren.sum((child) => 1 / child.badnessCoefficients.width),
      sumCoefficientsHeight,
    ),
    constantBadness: parametersChildren.sum((child) => child.constantBadness + child.badnessCoefficients.height * child.preferredSize.height.squared) - sumCoefficientsTimesPreferredHeight.squared / sumCoefficientsHeight,
  );
}

class Parameters extends OptimizationParameters<Parameters> {
  final Size preferredSize;
  final Size badnessCoefficients;
  final double constantBadness;

  Parameters({
    required double preferredWidth,
    required double preferredHeight,
    double? badnessMultiplierWidth,
    double? badnessMultiplierHeight,
    this.constantBadness = 0,
  })  : badnessCoefficients = Size((badnessMultiplierWidth ?? 1) / preferredWidth, (badnessMultiplierHeight ?? 1) / preferredHeight),
        preferredSize = Size(preferredWidth, preferredHeight);

  Parameters._fromRaw({
    required this.preferredSize,
    required this.badnessCoefficients,
    required this.constantBadness,
  });

  @override
  Parameters get transposed => Parameters._fromRaw(
        preferredSize: preferredSize.flipped,
        badnessCoefficients: badnessCoefficients.flipped,
        constantBadness: constantBadness,
      );
}
