import 'package:flutter/material.dart';
import 'package:rpn_calculator/combinatorics.dart';
import 'package:rpn_calculator/layout_optimization/layout_optimizer.dart';

class LeastSquareLayout extends StatelessWidget {
  final List<Optimizable<LeastSquareParameters>> children;

  LeastSquareLayout({required this.children});

  @override
  Widget build(BuildContext context) => LayoutOptimizer<LeastSquareParameters>(
        calculateBadnessForSize: (parameters, size) => parameters.badnessCoefficients.width * (size.width - parameters.preferredSize.width) * (size.width - parameters.preferredSize.width) + parameters.badnessCoefficients.height * (size.height - parameters.preferredSize.height) * (size.height - parameters.preferredSize.height) + parameters.constantBadness,
        getOptimalWidths: (parametersChildren, confinement) {
          final sumInvertedCoefficients = parametersChildren.sum((child) => 1 / child.badnessCoefficients.width);
          final sumPreferred = parametersChildren.sum((child) => child.preferredSize.width);
          return parametersChildren.map((child) => child.preferredSize.width + (confinement.width - sumPreferred) / sumInvertedCoefficients / child.badnessCoefficients.width).toList();
        },
        getParametersOfRow: (parametersChildren) {
          assert(children.isNotEmpty);
          if (children.length == 1) {
            return parametersChildren[0];
          }
          final double sumCoefficientsHeight = parametersChildren.sum((child) => child.badnessCoefficients.height);
          final double sumCoefficientsTimesPreferredHeight = parametersChildren.sum((child) => child.badnessCoefficients.height * child.preferredSize.height);
          Size preferredSize = Size(
            parametersChildren.sum((child) => child.preferredSize.width),
            sumCoefficientsTimesPreferredHeight / sumCoefficientsHeight,
          );
          Size badnessCoefficients = Size(
            1 / parametersChildren.sum((child) => 1 / child.badnessCoefficients.width),
            sumCoefficientsTimesPreferredHeight / sumCoefficientsHeight,
          );
          return LeastSquareParameters(
            preferredWidth: preferredSize.width,
            preferredHeight: preferredSize.height,
            badnessMultiplierWidth: badnessCoefficients.width,
            badnessMultiplierHeight: badnessCoefficients.height,
            constantBadness: parametersChildren.sum((child) => child.constantBadness + child.badnessCoefficients.height * child.preferredSize.height.squared) - sumCoefficientsTimesPreferredHeight.squared / sumCoefficientsHeight,
          );
        },
        children: children,
      );
}

class LeastSquareParameters extends OptimizationParameters<LeastSquareParameters> {
  final Size preferredSize;
  final Size badnessCoefficients;
  final double constantBadness;

  LeastSquareParameters({
    required double preferredWidth,
    required double preferredHeight,
    double? badnessMultiplierWidth,
    double? badnessMultiplierHeight,
    this.constantBadness = 0,
  })  : badnessCoefficients = Size((badnessMultiplierWidth ?? 1) / preferredWidth, (badnessMultiplierHeight ?? 1) / preferredHeight),
        preferredSize = Size(preferredWidth, preferredHeight);

  LeastSquareParameters._fromRaw({
    required this.preferredSize,
    required this.badnessCoefficients,
    required this.constantBadness,
  });

  @override
  LeastSquareParameters get transposed => LeastSquareParameters._fromRaw(
        preferredSize: preferredSize.flipped,
        badnessCoefficients: badnessCoefficients.flipped,
        constantBadness: constantBadness,
      );
}
