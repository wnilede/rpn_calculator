import 'package:flutter/material.dart';
import 'package:rpn_calculator/combinatorics.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';

OptimizationStrategy<Parameters> get strategy => OptimizationStrategy<Parameters>(
      calculateBadnessForSize: calculateBadnessForSize,
      getOptimalWidths: getOptimalWidths,
      getParametersOfRow: getParametersOfRow,
    );

double calculateBadnessForSize(Parameters parameters, Size size) {
  if (size.width < 0 || size.height < 0) {
    return double.infinity;
  }
  final widthParameter = parameters._getDirectedParameterWidth(size.width);
  final heightParameter = parameters._getDirectedParameterWidth(size.height);
  return widthParameter.badnessCoefficients * (size.width - widthParameter.preferredSize).squared + heightParameter.badnessCoefficients * (size.height - heightParameter.preferredSize).squared + widthParameter.constantBadness + heightParameter.constantBadness;
}

List<double> getOptimalWidths(List<Parameters> parametersChildren, Size confinement) {
  final result = List<double>.filled(parametersChildren.length, 1);
  final widthParameters = parametersChildren.map((child) => child._getDirectedParameterWidth(confinement.width)).toList();
  while (true) {
    double sumPreferred = 0;
    double sumInvertedCoefficients = 0;
    for (int i = 0; i < parametersChildren.length; i++) {
      if (result[i] > 0) {
        sumPreferred += widthParameters[i].preferredSize;
        sumInvertedCoefficients += 1 / widthParameters[i].badnessCoefficients;
      }
    }
    bool newVanishing = false;
    for (int i = 0; i < parametersChildren.length; i++) {
      if (result[i] > 0) {
        result[i] = widthParameters[i].preferredSize + (confinement.width - sumPreferred) / sumInvertedCoefficients / widthParameters[i].badnessCoefficients;
        if (result[i] < 0) {
          result[i] = 0;
          newVanishing = true;
        }
      }
    }
    if (!newVanishing) {
      return result;
    }
  }
}

Parameters getParametersOfRow(List<Parameters> parametersChildren) {
  assert(parametersChildren.isNotEmpty);
  if (parametersChildren.length == 1) {
    return parametersChildren[0];
  }
  _getWidthParametersOfRow(parametersChildren.map((child) => child.))
}

DirectedParameters _getWidthParametersOfRow(List<DirectedParameters> parametersChildren) {
  assert(parametersChildren.isNotEmpty);
  if (parametersChildren.length == 1) {
    return parametersChildren[0];
  }
  return DirectedParameters(
    preferredSize: parametersChildren.sum((child) => child.preferredSize),
    badnessCoefficients: 1 / parametersChildren.sum((child) => 1 / child.badnessCoefficients),
    constantBadness: parametersChildren.sum((child) => child.constantBadness),
  );
}

DirectedParameters _getHeightParametersOfRow(List<DirectedParameters> parametersChildren) {
  assert(parametersChildren.isNotEmpty);
  if (parametersChildren.length == 1) {
    return parametersChildren[0];
  }
  final double sumCoefficientsHeight = parametersChildren.sum((child) => child.badnessCoefficients);
  final double sumCoefficientsTimesPreferredHeight = parametersChildren.sum((child) => child.badnessCoefficients * child.preferredSize);
  return DirectedParameters(
    preferredSize: sumCoefficientsTimesPreferredHeight / sumCoefficientsHeight,
    badnessCoefficients: sumCoefficientsHeight,
    constantBadness: parametersChildren.sum((child) => child.constantBadness + child.badnessCoefficients * child.preferredSize.squared) - sumCoefficientsTimesPreferredHeight.squared / sumCoefficientsHeight,
  );
}

class DirectedParameters {
  final double preferredSize;
  final double badnessCoefficients;
  final double constantBadness;

  DirectedParameters({
    required this.preferredSize,
    required this.badnessCoefficients,
    required this.constantBadness,
  });
}

class Parameters extends OptimizationParameters<Parameters> {
  final List<DirectedParameters> horizontalParts;
  final List<double> horizontalChangingPoints;
  final List<DirectedParameters> verticalParts;
  final List<double> verticalChangingPoints;

  Parameters({
    required double preferredWidth,
    required double preferredHeight,
    double? badnessMultiplierWidth,
    double? badnessMultiplierHeight,
    double constantBadness = 0,
  })  : horizontalParts = [
          DirectedParameters(
            badnessCoefficients: (badnessMultiplierWidth ?? 1) / preferredWidth,
            preferredSize: preferredWidth,
            constantBadness: constantBadness,
          ),
        ],
        verticalParts = [
          DirectedParameters(
            badnessCoefficients: (badnessMultiplierHeight ?? 1) / preferredHeight,
            preferredSize: preferredHeight,
            constantBadness: 0,
          ),
        ],
        verticalChangingPoints = [],
        horizontalChangingPoints = [];

  Parameters._fromRaw({
    required this.horizontalParts,
    required this.horizontalChangingPoints,
    required this.verticalParts,
    required this.verticalChangingPoints,
  }) : assert(horizontalParts.length == horizontalChangingPoints.length + 1 && verticalParts.length == verticalChangingPoints.length + 1);

  @override
  Parameters get transposed => Parameters._fromRaw(
        horizontalParts: verticalParts,
        verticalParts: horizontalParts,
        verticalChangingPoints: horizontalChangingPoints,
        horizontalChangingPoints: horizontalChangingPoints,
      );

  DirectedParameters _getDirectedParameterWidth(double width) => horizontalParts[width > horizontalChangingPoints.last ? horizontalChangingPoints.length : horizontalChangingPoints.indexWhere((changingPoint) => width > changingPoint)];
  DirectedParameters _getDirectedParameterHeight(double height) => transposed._getDirectedParameterWidth(height);
}
