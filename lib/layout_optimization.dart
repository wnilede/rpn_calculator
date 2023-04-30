import 'package:flutter/material.dart';
import 'package:rpn_calculator/combinatorics.dart';

class Optimizable extends StatelessWidget {
  final Widget child;
  final Size preferredSize;
  final Size badnessCoefficients;
  final double constantBadness;

  Optimizable({
    required this.child,
    required double preferredWidth,
    required double preferredHeight,
    double? badnessMultiplierWidth,
    double? badnessMultiplierHeight,
    this.constantBadness = 0,
  })  : badnessCoefficients = Size((badnessMultiplierWidth ?? 1) / preferredWidth, (badnessMultiplierHeight ?? 1) / preferredHeight),
        preferredSize = Size(preferredWidth, preferredHeight);
  factory Optimizable._childrenInLine({required List<Optimizable> children, bool vertical = false}) {
    assert(children.isNotEmpty);
    if (children.length == 1) {
      return children[0];
    }
    final double sumPreferredMain = children.sum((child) => _mainAxisSize(child, vertical));
    final double sumCoefficientsInvertedMain = children.sum((child) => 1 / _mainAxisCoefficient(child, vertical));
    final double sumCoefficientsCross = children.sum((child) => _crossAxisCoefficient(child, vertical));
    final double sumCoefficientsTimesPreferredCross = children.sum((child) => _crossAxisCoefficient(child, vertical) * _crossAxisSize(child, vertical));
    final double sumCoefficientsTimesPreferredSquaredCross = children.sum((child) => _crossAxisCoefficient(child, vertical) * _crossAxisSize(child, vertical) * _crossAxisSize(child, vertical));
    final double sumConstantBadness = children.sum((child) => child.constantBadness);
    Size preferredSize = Size(
      sumPreferredMain,
      sumCoefficientsTimesPreferredCross / sumCoefficientsCross,
    );
    Size badnessCoefficients = Size(
      1 / sumCoefficientsInvertedMain,
      sumCoefficientsTimesPreferredCross / sumCoefficientsCross,
    );
    if (vertical) {
      preferredSize = preferredSize.flipped;
      badnessCoefficients = badnessCoefficients.flipped;
    }
    return Optimizable(
      preferredWidth: preferredSize.width,
      preferredHeight: preferredSize.height,
      badnessMultiplierWidth: badnessCoefficients.width,
      badnessMultiplierHeight: badnessCoefficients.height,
      constantBadness: sumConstantBadness + sumCoefficientsTimesPreferredSquaredCross - sumCoefficientsTimesPreferredCross * sumCoefficientsTimesPreferredCross / sumCoefficientsCross,
      child: _Line(children, vertical),
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }

  double calculateBadnessForSize(Size size) => badnessCoefficients.width * (size.width - preferredSize.width) * (size.width - preferredSize.width) + badnessCoefficients.height * (size.height - preferredSize.height) * (size.height - preferredSize.height) + constantBadness;
  static List<Optimizable> _findAllLayouts({required List<Optimizable> children, required bool vertical}) {
    if (children.isEmpty) {
      return [];
    }
    if (children.length == 1) {
      return [
        children[0]
      ];
    }
    List<Optimizable> result = [];
    for (List<List<Optimizable>> grouping in getAllPossibleGroupings(children)) {
      // The grouping consisting of a single group with containing every child produces the same layout as the grouping consisting of as many groups as there are children with one child in each. These groupings are not the same (we already checked that there were more than one child), so we can ignore one of them.
      if (grouping.length == 1) {
        continue;
      }
      // Add all possible layouts where the children are grouped according to grouping.
      result.addAll(
        grouping
            // Get all possible layouts for each group.
            .map(
              (group) => _findAllLayouts(
                children: group,
                vertical: !vertical,
              ),
            )
            .toList()
            // Go through all possible ways of choosing one layout for each group.
            .oneFromEach()
            // For each way to choose the childrens layouts, put the layouts in a row or column.
            .map(
              (children) => Optimizable._childrenInLine(
                vertical: vertical,
                children: children,
              ),
            ),
      );
    }
    return result;
  }

  static double _mainAxisSize(Optimizable child, bool vertical) => vertical ? child.preferredSize.height : child.preferredSize.width;
  static double _crossAxisSize(Optimizable child, bool vertical) => vertical ? child.preferredSize.width : child.preferredSize.height;
  static double _mainAxisCoefficient(Optimizable child, bool vertical) => vertical ? child.badnessCoefficients.height : child.badnessCoefficients.width;
  static double _crossAxisCoefficient(Optimizable child, bool vertical) => vertical ? child.badnessCoefficients.width : child.badnessCoefficients.height;
}

class LayoutOptimizer extends StatelessWidget {
  final List<Optimizable> children;

  const LayoutOptimizer({super.key, required this.children});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => _findAllLayouts().minimizes((possibility) => possibility.calculateBadnessForSize(constraints.biggest)),
      );

  List<Optimizable> _findAllLayouts() => Optimizable._findAllLayouts(
        vertical: true,
        children: children,
      )..addAll(
          Optimizable._findAllLayouts(
            vertical: false,
            children: children,
          ),
        );
}

class _Line extends StatelessWidget {
  final List<Optimizable> children;
  final bool vertical;

  _Line(this.children, this.vertical);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sumInvertedCoefficients = children.sum((child) => 1 / (vertical ? child.badnessCoefficients.height : child.badnessCoefficients.width));
        final sumPreferred = children.sum((child) => vertical ? child.preferredSize.height : child.preferredSize.width);
        final resizedChildren = children.map(
          (child) {
            return SizedBox(
              width: vertical ? constraints.maxWidth : child.preferredSize.width + (constraints.maxWidth - sumPreferred) / sumInvertedCoefficients / child.badnessCoefficients.width,
              height: vertical ? child.preferredSize.height + (constraints.maxHeight - sumPreferred) / sumInvertedCoefficients / child.badnessCoefficients.height : constraints.maxHeight,
              child: child,
            );
          },
        ).toList();
        if (vertical) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: resizedChildren,
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: resizedChildren,
          );
        }
      },
    );
  }
}
