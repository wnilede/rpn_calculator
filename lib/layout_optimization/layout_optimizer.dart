import 'package:flutter/material.dart';
import 'package:rpn_calculator/combinatorics.dart';

class LayoutOptimizer<TParameters extends OptimizationParameters<TParameters>> extends StatelessWidget {
  final OptimizationStrategy<TParameters> strategy;
  final List<Optimizable<TParameters>> children;

  LayoutOptimizer({
    required this.strategy,
    required this.children,
  });

  List<Optimizable<TParameters>> _findAllLayoutsInDirection({required List<Optimizable<TParameters>> children, required bool vertical}) {
    if (children.isEmpty) {
      return [];
    }
    if (children.length == 1) {
      return [
        children[0]
      ];
    }
    List<Optimizable<TParameters>> result = [];
    for (List<List<Optimizable<TParameters>>> grouping in getAllPossibleGroupings(children)) {
      // The grouping consisting of a single group with containing every child produces the same layout as the grouping consisting of as many groups as there are children with one child in each. These groupings are not the same (we already checked that there were more than one child), so we can ignore one of them.
      if (grouping.length == 1) {
        continue;
      }
      // Add all possible layouts where the children are grouped according to grouping.
      result.addAll(
        grouping
            // Get all possible layouts for each group.
            .map(
              (group) => _findAllLayoutsInDirection(
                children: group,
                vertical: !vertical,
              ),
            )
            .toList()
            // Go through all possible ways of choosing one layout for each group.
            .oneFromEach()
            // For each way to choose the childrens layouts, put the layouts in a row or column.
            .map(
              (children) => _childrenInLine(
                vertical: vertical,
                children: children,
              ),
            ),
      );
    }
    return result;
  }

  Optimizable<TParameters> _childrenInLine({required List<Optimizable<TParameters>> children, bool vertical = false}) {
    assert(children.isNotEmpty);
    if (children.length == 1) {
      return children[0];
    }
    List<TParameters> parametersChildren = children.map((child) => vertical ? child.parameters.transposed : child.parameters).toList();
    TParameters parameters = strategy.getParametersOfRow(parametersChildren);
    return Optimizable<TParameters>(
      parameters: vertical ? parameters.transposed : parameters,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sizes = strategy.getOptimalWidths(parametersChildren, vertical ? constraints.biggest.flipped : constraints.biggest);
          final resizedChildren = <Widget>[];
          for (int i = 0; i < sizes.length; i++) {
            resizedChildren.add(
              SizedBox(
                width: vertical ? constraints.maxWidth : sizes[i],
                height: vertical ? sizes[i] : constraints.maxHeight,
                child: children[i],
              ),
            );
          }
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
      ),
    );
  }

  List<Optimizable<TParameters>> findAllLayouts(List<Optimizable<TParameters>> children) => _findAllLayoutsInDirection(
        vertical: false,
        children: children,
      )..addAll(
          _findAllLayoutsInDirection(
            vertical: true,
            children: children,
          ),
        );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => findAllLayouts(children).minimizes(
          (possibility) => strategy.calculateBadnessForSize(possibility.parameters, constraints.biggest),
        ),
      );
}

class OptimizationStrategy<TParameters extends OptimizationParameters<TParameters>> {
  // Determine how bad a size is for an optimizable with specified parameters.
  final double Function(TParameters parameters, Size size) calculateBadnessForSize;

  // Should return the widths of the children that minimizes the sum of the badness for them if placed in a row.
  final List<double> Function(List<TParameters> parametersChildren, Size confinement) getOptimalWidths;

  // Should return the parameters for a row containing children with given parameters.
  final TParameters Function(List<TParameters> parametersChildren) getParametersOfRow;

  OptimizationStrategy({required this.calculateBadnessForSize, required this.getOptimalWidths, required this.getParametersOfRow});
}

class Optimizable<TParameters extends OptimizationParameters<TParameters>> extends StatelessWidget {
  final TParameters parameters;
  final Widget child;

  Optimizable({required this.parameters, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

abstract class OptimizationParameters<T extends OptimizationParameters<T>> {
  T get transposed;
}
